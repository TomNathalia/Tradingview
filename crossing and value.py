//@version=5
indicator("MACD Crossovers Table", shorttitle="MACD Crossovers", overlay=true)

// Helper function to round values to 2 decimal places
RoundToTens(value) =>
    math.round(value * 100) / 100

// Function to calculate the MACD crossover or crossunder for a given timeframe
get_macd_cross(tf) =>
    [macd_line, signal_line, _] = request.security(syminfo.tickerid, tf, ta.macd(close, 12, 26, 9))
    var string cross_type = na
    var float macd_value_at_cross = na
    if ta.crossover(macd_line, signal_line)
        cross_type := "Crossover"
        macd_value_at_cross := macd_line
    else if ta.crossunder(macd_line, signal_line)
        cross_type := "Crossunder"
        macd_value_at_cross := macd_line
    [cross_type, macd_value_at_cross]

// Destructure MACD crossovers for different timeframes
[cross_type_1m, macd_value_1m] = get_macd_cross("1")
[cross_type_3m, macd_value_3m] = get_macd_cross("3")
[cross_type_5m, macd_value_5m] = get_macd_cross("5")
[cross_type_15m, macd_value_15m] = get_macd_cross("15")
[cross_type_1h, macd_value_1h] = get_macd_cross("60")
[cross_type_4h, macd_value_4h] = get_macd_cross("240")
[cross_type_1d, macd_value_1d] = get_macd_cross("D")

// Create table
var table macd_table = table.new(position.bottom_right, 3, 8, bgcolor=color.new(color.gray, 90))

// Populate table headers
if bar_index == 0
    table.cell(macd_table, 0, 0, text="Timeframe", bgcolor=color.new(color.blue, 85), text_color=color.white)
    table.cell(macd_table, 1, 0, text="Cross Type", bgcolor=color.new(color.blue, 85), text_color=color.white)
    table.cell(macd_table, 2, 0, text="MACD Value", bgcolor=color.new(color.blue, 85), text_color=color.white)

// Add row data for each timeframe
add_row(tf, cross_type, macd_value, row) =>
    cross_color = cross_type == "Crossover" ? color.new(color.green, 0) : (cross_type == "Crossunder" ? color.new(color.red, 0) : color.gray)
    table.cell(macd_table, 0, row, text=tf, bgcolor=color.new(color.gray, 85), text_color=color.white)
    table.cell(macd_table, 1, row, text=not na(cross_type) ? cross_type : "N/A", bgcolor=cross_color, text_color=color.white)
    table.cell(macd_table, 2, row, text=not na(macd_value) ? str.tostring(RoundToTens(macd_value)) : "N/A", bgcolor=color.new(color.gray, 85), text_color=color.white)

// Populate table rows for each timeframe
add_row("1m", cross_type_1m, macd_value_1m, 1)
add_row("3m", cross_type_3m, macd_value_3m, 2)
add_row("5m", cross_type_5m, macd_value_5m, 3)
add_row("15m", cross_type_15m, macd_value_15m, 4)
add_row("1h", cross_type_1h, macd_value_1h, 5)
add_row("4h", cross_type_4h, macd_value_4h, 6)
add_row("1d", cross_type_1d, macd_value_1d, 7)
