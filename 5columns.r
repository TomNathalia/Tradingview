//@version=5
indicator("EMA 200 & RSI Table", shorttitle="EMA 200 & RSI", overlay=true)

// Function to determine if the price is above or below EMA for a given timeframe
is_above_ema(src, length, tf) =>
    ema_value = request.security(syminfo.tickerid, tf, ta.ema(src, length))
    close > ema_value ? "Above" : "Below"

// Function to calculate RSI for a given timeframe
get_rsi(src, length, tf) =>
    request.security(syminfo.tickerid, tf, ta.rsi(src, length))

// Function to calculate MACD crossover or crossunder for a given timeframe
get_macd_cross(tf) =>
    [macd_line, signal_line, _] = request.security(syminfo.tickerid, tf, ta.macd(close, 12, 26, 9))
    var string cross_type = na
    var float macd_value_at_cross = na
    var string cross_time = na
    if ta.crossover(macd_line, signal_line)
        cross_type := "Over"
        macd_value_at_cross := macd_line
        cross_time := str.format("{0,date,dd/MM HH:mm}", time) // Use `time` for accurate bar timestamps
    else if ta.crossunder(macd_line, signal_line)
        cross_type := "Under"
        macd_value_at_cross := macd_line
        cross_time := str.format("{0,date,dd/MM HH:mm}", time) // Use `time` for accurate bar timestamps
    [cross_type, macd_value_at_cross, cross_time]

// Function to calculate average volatility in percentage over the last 20 candles for a given timeframe
get_volatility(tf) =>
    vol_changes = request.security(syminfo.tickerid, tf, ((high - low) / low) * 100)  // Calculate per-candle volatility in % directly from the timeframe
    avg_volatility = ta.sma(vol_changes, 20)  // Take the SMA of the calculated values
    avg_volatility

// Create the table
var table ema_table = table.new(position.bottom_right, 5, 8, bgcolor=color.new(color.gray, 90))

// Populate the table header
if bar_index == 0
    table.cell(ema_table, 0, 0, text="Timeframe", bgcolor=color.new(color.blue, 85), text_color=color.white)
    table.cell(ema_table, 1, 0, text="EMA 200", bgcolor=color.new(color.blue, 85), text_color=color.white)
    table.cell(ema_table, 2, 0, text="RSI", bgcolor=color.new(color.blue, 85), text_color=color.white)
    table.cell(ema_table, 3, 0, text="Cross Time", bgcolor=color.new(color.blue, 85), text_color=color.white)
    table.cell(ema_table, 4, 0, text="Volatility", bgcolor=color.new(color.blue, 85), text_color=color.white)

// Check EMA 200 status and RSI for different timeframes
status_1m = is_above_ema(close, 200, "1")
status_3m = is_above_ema(close, 200, "3")
status_5m = is_above_ema(close, 200, "5")
status_15m = is_above_ema(close, 200, "15")
status_1h = is_above_ema(close, 200, "60")
status_4h = is_above_ema(close, 200, "240")
status_1d = is_above_ema(close, 200, "D")

rsi_1m = get_rsi(close, 14, "1")
rsi_3m = get_rsi(close, 14, "3")
rsi_5m = get_rsi(close, 14, "5")
rsi_15m = get_rsi(close, 14, "15")
rsi_1h = get_rsi(close, 14, "60")
rsi_4h = get_rsi(close, 14, "240")
rsi_1d = get_rsi(close, 14, "D")

[cross_type_1m, macd_value_1m, cross_time_1m] = get_macd_cross("1")
volatility_1m = get_volatility("1")

[cross_type_3m, macd_value_3m, cross_time_3m] = get_macd_cross("3")
volatility_3m = get_volatility("3")

[cross_type_5m, macd_value_5m, cross_time_5m] = get_macd_cross("5")
volatility_5m = get_volatility("5")

[cross_type_15m, macd_value_15m, cross_time_15m] = get_macd_cross("15")
volatility_15m = get_volatility("15")

[cross_type_1h, macd_value_1h, cross_time_1h] = get_macd_cross("60")
volatility_1h = get_volatility("60")

[cross_type_1d, macd_value_1d, cross_time_1d] = get_macd_cross("D")
volatility_1d = get_volatility("D")

time_to_string(timestamp) =>
    na(timestamp) ? "N/A" : str.format("{0,date,dd/MM HH:mm}", timestamp)

// Helper function to set RSI cell color
get_rsi_color(rsi) =>
    rsi > 75 ? color.new(#FF4C4C, 0) : rsi < 25 ? color.new(#00FF00, 0) : color.new(color.gray, 85)

// Populate the table with timeframe labels, EMA statuses, RSI values, cross times, and volatility
table.cell(ema_table, 0, 1, text="1m", bgcolor=color.new(color.gray, 85), text_color=color.white)
table.cell(ema_table, 1, 1, text=status_1m, bgcolor=status_1m == "Above" ? color.new(#00FF00, 0) : color.new(#FF4C4C, 0), text_color=status_1m == "Above" ? color.black : color.white)
table.cell(ema_table, 2, 1, text=str.tostring(rsi_1m, format.mintick), bgcolor=get_rsi_color(rsi_1m), text_color=color.white)
table.cell(ema_table, 3, 1, text=not na(cross_time_1m) ? cross_time_1m : "N/A", bgcolor=color.new(color.gray, 85), text_color=color.white)
table.cell(ema_table, 4, 1, text=not na(volatility_1m) ? str.tostring(volatility_1m, format.mintick) + "%" : "N/A", bgcolor=color.new(color.gray, 85), text_color=color.white)

table.cell(ema_table, 0, 2, text="3m", bgcolor=color.new(color.gray, 85), text_color=color.white)
table.cell(ema_table, 1, 2, text=status_3m, bgcolor=status_3m == "Above" ? color.new(#00FF00, 0) : color.new(#FF4C4C, 0), text_color=status_3m == "Above" ? color.black : color.white)
table.cell(ema_table, 2, 2, text=str.tostring(rsi_3m, format.mintick), bgcolor=get_rsi_color(rsi_3m), text_color=color.white)
table.cell(ema_table, 3, 2, text=not na(cross_time_3m) ? cross_time_3m : "N/A", bgcolor=color.new(color.gray, 85), text_color=color.white)
table.cell(ema_table, 4, 2, text=not na(volatility_3m) ? str.tostring(volatility_3m, format.mintick) + "%" : "N/A", bgcolor=color.new(color.gray, 85), text_color=color.white)

table.cell(ema_table, 0, 3, text="5m", bgcolor=color.new(color.gray, 85), text_color=color.white)
table.cell(ema_table, 1, 3, text=status_5m, bgcolor=status_5m == "Above" ? color.new(#00FF00, 0) : color.new(#FF4C4C, 0), text_color=status_5m == "Above" ? color.black : color.white)
table.cell(ema_table, 2, 3, text=str.tostring(rsi_5m, format.mintick), bgcolor=get_rsi_color(rsi_5m), text_color=color.white)
table.cell(ema_table, 3, 3, text=not na(cross_time_5m) ? cross_time_5m : "N/A", bgcolor=color.new(color.gray, 85), text_color=color.white)
table.cell(ema_table, 4, 3, text=not na(volatility_5m) ? str.tostring(volatility_5m, format.mintick) + "%" : "N/A", bgcolor=color.new(color.gray, 85), text_color=color.white)

table.cell(ema_table, 0, 4, text="15m", bgcolor=color.new(color.gray, 85), text_color=color.white)
table.cell(ema_table, 1, 4, text=status_15m, bgcolor=status_15m == "Above" ? color.new(#00FF00, 0) : color.new(#FF4C4C, 0), text_color=status_15m == "Above" ? color.black : color.white)
table.cell(ema_table, 2, 4, text=str.tostring(rsi_15m, format.mintick), bgcolor=get_rsi_color(rsi_15m), text_color=color.white)
table.cell(ema_table, 3, 4, text=not na(cross_time_15m) ? cross_time_15m : "N/A", bgcolor=color.new(color.gray, 85), text_color=color.white)
table.cell(ema_table, 4, 4, text=not na(volatility_15m) ? str.tostring(volatility_15m, format.mintick) + "%" : "N/A", bgcolor=color.new(color.gray, 85), text_color=color.white)

table.cell(ema_table, 0, 5, text="1h", bgcolor=color.new(color.gray, 85), text_color=color.white)
table.cell(ema_table, 1, 5, text=status_1h, bgcolor=status_1h == "Above" ? color.new(#00FF00, 0) : color.new(#FF4C4C, 0), text_color=status_1h == "Above" ? color.black : color.white)
table.cell(ema_table, 2, 5, text=str.tostring(rsi_1h, format.mintick), bgcolor=get_rsi_color(rsi_1h), text_color=color.white)
table.cell(ema_table, 3, 5, text=not na(cross_time_1h) ? cross_time_1h : "N/A", bgcolor=color.new(color.gray, 85), text_color=color.white)
table.cell(ema_table, 4, 5, text=not na(volatility_1h) ? str.tostring(volatility_1h, format.mintick) + "%" : "N/A", bgcolor=color.new(color.gray, 85), text_color=color.white)

table.cell(ema_table, 0, 6, text="1d", bgcolor=color.new(color.gray, 85), text_color=color.white)
table.cell(ema_table, 1, 6, text=status_1d, bgcolor=status_1d == "Above" ? color.new(#00FF00, 0) : color.new(#FF4C4C, 0), text_color=status_1d == "Above" ? color.black : color.white)
table.cell(ema_table, 2, 6, text=str.tostring(rsi_1d, format.mintick), bgcolor=get_rsi_color(rsi_1d), text_color=color.white)
table.cell(ema_table, 3, 6, text=not na(cross_time_1d) ? cross_time_1d : "N/A", bgcolor=color.new(color.gray, 85), text_color=color.white)
table.cell(ema_table, 4, 6, text=not na(volatility_1d) ? str.tostring(volatility_1d, format.mintick) + "%" : "N/A", bgcolor=color.new(color.gray, 85), text_color=color.white)
