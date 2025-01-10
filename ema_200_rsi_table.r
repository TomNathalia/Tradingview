//@version=5
indicator("EMA 200 & RSI Table", shorttitle="EMA 200 & RSI", overlay=true)

// Function to determine if the price is above or below EMA for a given timeframe
is_above_ema(src, length, tf) =>
    ema_value = request.security(syminfo.tickerid, tf, ta.ema(src, length))
    close > ema_value ? "Above" : "Below"

// Function to calculate RSI for a given timeframe
get_rsi(src, length, tf) =>
    request.security(syminfo.tickerid, tf, ta.rsi(src, length))

// Create the table
var table ema_table = table.new(position.bottom_right, 4, 8, bgcolor=color.new(color.gray, 90))

// Populate the table header
if bar_index == 0
    table.cell(ema_table, 0, 0, text="Timeframe", bgcolor=color.new(color.blue, 85), text_color=color.white)
    table.cell(ema_table, 1, 0, text="EMA 200", bgcolor=color.new(color.blue, 85), text_color=color.white)
    table.cell(ema_table, 2, 0, text="RSI", bgcolor=color.new(color.blue, 85), text_color=color.white)

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

// Helper function to set RSI cell color
get_rsi_color(rsi) =>
    rsi > 75 ? color.new(#FF4C4C, 0) : rsi < 25 ? color.new(#00FF00, 0) : color.new(color.gray, 85)

// Populate the table with timeframe labels, EMA statuses, and RSI values
table.cell(ema_table, 0, 1, text="1m", bgcolor=color.new(color.gray, 85), text_color=color.white)
table.cell(ema_table, 1, 1, text=status_1m, bgcolor=status_1m == "Above" ? color.new(#00FF00, 0) : color.new(#FF4C4C, 0), text_color=status_1m == "Above" ? color.black : color.white)
table.cell(ema_table, 2, 1, text=str.tostring(rsi_1m, format.mintick), bgcolor=get_rsi_color(rsi_1m), text_color=color.white)

table.cell(ema_table, 0, 2, text="3m", bgcolor=color.new(color.gray, 85), text_color=color.white)
table.cell(ema_table, 1, 2, text=status_3m, bgcolor=status_3m == "Above" ? color.new(#00FF00, 0) : color.new(#FF4C4C, 0), text_color=status_3m == "Above" ? color.black : color.white)
table.cell(ema_table, 2, 2, text=str.tostring(rsi_3m, format.mintick), bgcolor=get_rsi_color(rsi_3m), text_color=color.white)

table.cell(ema_table, 0, 3, text="5m", bgcolor=color.new(color.gray, 85), text_color=color.white)
table.cell(ema_table, 1, 3, text=status_5m, bgcolor=status_5m == "Above" ? color.new(#00FF00, 0) : color.new(#FF4C4C, 0), text_color=status_5m == "Above" ? color.black : color.white)
table.cell(ema_table, 2, 3, text=str.tostring(rsi_5m, format.mintick), bgcolor=get_rsi_color(rsi_5m), text_color=color.white)

table.cell(ema_table, 0, 4, text="15m", bgcolor=color.new(color.gray, 85), text_color=color.white)
table.cell(ema_table, 1, 4, text=status_15m, bgcolor=status_15m == "Above" ? color.new(#00FF00, 0) : color.new(#FF4C4C, 0), text_color=status_15m == "Above" ? color.black : color.white)
table.cell(ema_table, 2, 4, text=str.tostring(rsi_15m, format.mintick), bgcolor=get_rsi_color(rsi_15m), text_color=color.white)

table.cell(ema_table, 0, 5, text="1h", bgcolor=color.new(color.gray, 85), text_color=color.white)
table.cell(ema_table, 1, 5, text=status_1h, bgcolor=status_1h == "Above" ? color.new(#00FF00, 0) : color.new(#FF4C4C, 0), text_color=status_1h == "Above" ? color.black : color.white)
table.cell(ema_table, 2, 5, text=str.tostring(rsi_1h, format.mintick), bgcolor=get_rsi_color(rsi_1h), text_color=color.white)

table.cell(ema_table, 0, 6, text="4h", bgcolor=color.new(color.gray, 85), text_color=color.white)
table.cell(ema_table, 1, 6, text=status_4h, bgcolor=status_4h == "Above" ? color.new(#00FF00, 0) : color.new(#FF4C4C, 0), text_color=status_4h == "Above" ? color.black : color.white)
table.cell(ema_table, 2, 6, text=str.tostring(rsi_4h, format.mintick), bgcolor=get_rsi_color(rsi_4h), text_color=color.white)

table.cell(ema_table, 0, 7, text="1d", bgcolor=color.new(color.gray, 85), text_color=color.white)
table.cell(ema_table, 1, 7, text=status_1d, bgcolor=status_1d == "Above" ? color.new(#00FF00, 0) : color.new(#FF4C4C, 0), text_color=status_1d == "Above" ? color.black : color.white)
table.cell(ema_table, 2, 7, text=str.tostring(rsi_1d, format.mintick), bgcolor=get_rsi_color(rsi_1d), text_color=color.white)
