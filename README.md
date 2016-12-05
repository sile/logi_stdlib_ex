logi_stdlib_ex
==============

[![hex.pm version](https://img.shields.io/hexpm/v/logi_stdlib_ex.svg)](https://hex.pm/packages/logi_stdlib_ex)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

This is a wrapper library of [logi_stdlib](https://github.com/sile/logi_stdlib).

[Documentation](https://hexdocs.pm/logi_stdlib_ex/)

`logi_stdlib` is the standard library for [logi](https://github.com/sile/logi).

Installation
------------

Add `logi_stdlib_ex` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:logi_stdlib_ex, "~> 0.1"}]
end
```

Ensure `logi_stdlib_ex` is started before your application:

```elixir
def application do
  [applications: [:logi_stdlib_ex]]
end
```

Examples
--------

### Outputs to console and file

```elixir
# Installs sinks
iex> console_sink = LogiStd.Sink.Console.new :console
iex> file_sink = LogiStd.Sink.File.new :file, "alert.log"
iex> {:ok, _} = Logi.Channel.install_sink console_sink, :info
iex> {:ok, _} = Logi.Channel.install_sink file_sink, :alert

# Outputs an info message
iex> require Logi
iex> Logi.info "Hello World!"
2016-12-06 00:29:09.857 [info] nonode@nohost <0.380.0> nil:nil:7 [] Hello World!

iex> :file.read_file "alert.log"
{:ok, ""}  # Info messages are ignored by `file_sink`

# Outputs an alert message
iex> Logi.alert "Something Wrong"
2016-12-06 00:31:36.386 [alert] nonode@nohost <0.380.0> nil:nil:9 [] Something Wrong

iex> :file.read_file "alert.log"
{:ok, "2016-12-06 00:31:36.386 [alert] nonode@nohost <0.380.0> nil:nil:9 [] Something Wrong\n"}
```

### Forwards error_logger messages

```elixir
# Enables macro and installs a sink
iex> require Logi
iex> {:ok, _} = Logi.Channel.install_sink LogiStd.Sink.Console.new(:console), :info

# Installs Logi's error_logger handler
iex> :ok = LogiStd.Source.ErrorLogger.install

# Log messages via error_logger module
> :error_logger.info_msg "Hello World!"
2016-12-06 00:38:44.216 [info] nonode@nohost <0.30.0> logi_source_error_logger:default_log_fun:144 [gleader=<0.33.0>,sender=<0.148.0>] Hello World!
```

### Frequency control per logger

```elixir
# Enables macro and installs a sink
iex> require Logi
iex> {:ok, _} = Logi.Channel.install_sink LogiStd.Sink.Console.new(:console), :info

# Setup logger instance with a `LogiStd.Filter.Frequency` filter
# LIMIT: 3 messages per second
iex> filter = LogiStd.Filter.Frequency.new [max_count: 3, period: 1000]
iex> Logi.save_as_default Logi.new([filter: filter])

# Log messages
iex> Enum.each 1..10, fn (i) -> Logi.info("Hello: ~p", [i]) end
2016-12-06 00:48:01.647 [info] nonode@nohost <0.148.0> nil:nil:10 [] Hello: 1
2016-12-06 00:48:01.647 [info] nonode@nohost <0.148.0> nil:nil:10 [] Hello: 2
2016-12-06 00:48:01.647 [info] nonode@nohost <0.148.0> nil:nil:10 [] Hello: 3

iex> :timer.sleep 1000  # Waits until current period has been passed

iex> Logi.info "World!"
2016-12-06 00:48:03.058 [info] nonode@nohost <0.148.0> nil:nil:10 [] Over a period of 1.41 seconds, 7 messages were dropped
2016-12-06 00:48:03.058 [info] nonode@nohost <0.148.0> nil:nil:12 [] World!
```

### Frequency control per sink

```elixir
# Enables macro
iex> require Logi

# Installs a sink
# LIMIT: 300 bytes per second
iex> inner_sink = LogiStd.Sink.Console.new(:console)
iex> sink = LogiStd.Sink.FlowLimiter.new :limiter, inner_sink, [write_rate_limits: [{300, 1000}]]
iex> {:ok, _} = Logi.Channel.install_sink sink, :info

# Log messages
iex> Enum.each 1..10, fn (i) -> Logi.info("Hello: ~p", [i]) end
2016-12-06 01:01:12.381 [info] nonode@nohost <0.148.0> nil:nil:19 [] Hello: 1
2016-12-06 01:01:12.381 [info] nonode@nohost <0.148.0> nil:nil:19 [] Hello: 2
2016-12-06 01:01:12.381 [info] nonode@nohost <0.148.0> nil:nil:19 [] Hello: 3
2016-12-06 01:01:12.381 [info] nonode@nohost <0.148.0> nil:nil:19 [] Hello: 4
2016-12-06 01:01:25.396 [warning] nonode@nohost <0.211.0> logi_sink_flow_limiter_writer:report_omissions:189 [] Over a period of 60 seconds, 6 info messages were omitted: channel=logi_default_log, reason=rate_exceeded (e.g. [{pid,module,line},{<0.148.0>,nil,19}])
```

### High Availability Configuration

```elixir
# Installs sinks
iex> file1 = LogiStd.Sink.File.new :file1, "file1.log"
iex> file2 = LogiStd.Sink.File.new :file2, "file2.log"
iex> ha_logger = :null  # Suppresses HA's log messages which are noisy for this example
iex> sink = LogiStd.Sink.HA.new :ha, [%{:sink => file1}, %{:sink => file2}], [strategy: :first_available, logger: ha_logger]
iex> {:ok, _} = Logi.Channel.install_sink sink, :info

iex> require Logi

# First available sink is `file1`
iex> Logi.info "Hello"
iex> :file.read_file "file1.log"
{:ok, "2016-12-06 01:11:19.821 [info] nonode@nohost <0.148.0> nil:nil:16 [] Hello\n"}
iex> :file.read_file "file2.log"
{:ok, ""}

# Removes permission of file1 and forces reopen
iex> :file.change_mode "file1.log", 0
iex> :erlang.exit(Logi.Channel.whereis_sink_proc([:ha, :file1]), :kill)

# Now, first available sink is `file2`
iex> Logi.info "World!"
> :file.read_file "file2.log"
{:ok, "2016-12-06 01:14:51.544 [info] nonode@nohost <0.148.0> nil:nil:26 [] World!\n"}
```
