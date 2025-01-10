//@version=5
indicator("MACD Table", shorttitle="MACD", overlay=true)

// Helper function to round values to 2 decimal places
RoundToTens(value) =>
    math.round(value * 100) / 100

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

// Destructure MACD crossovers for different timeframes
[cross_type_1m, macd_value_1m, cross_time_1m] = get_macd_cross("1")
[cross_type_3m, macd_value_3m, cross_time_3m] = get_macd_cross("3")
[cross_type_5m, macd_value_5m, cross_time_5m] = get_macd_cross("5")
[cross_type_15m, macd_value_15m, cross_time_15m] = get_macd_cross("15")
[cross_type_1h, macd_value_1h, cross_time_1h] = get_macd_cross("60")
[cross_type_1d, macd_value_1d, cross_time_1d] = get_macd_cross("D")

time_to_string(timestamp) =>
    na(timestamp) ? "N/A" : str.format("{0,date,dd/MM HH:mm}", timestamp)

// Create table
var table macd_table = table.new(position.bottom_right, 2, 7, bgcolor=color.new(color.gray, 90))  // Updated size to remove "Volatility" column

// Populate table headers
if bar_index == 0
    table.cell(macd_table, 0, 0, text="Cross Time", bgcolor=color.new(color.blue, 85), text_color=color.white)  // "Cross Time" as the first column

// Add row data for each timeframe
add_row(tf, cross_time, cross_type, macd_value, row) =>
    // Color logic for Cross Time
    cross_color = cross_type == "Over" and macd_value < 0 ? color.new(color.green, 0) : cross_type == "Under" and macd_value > 0 ? color.new(color.red, 0) : color.gray
    
    // Populate table cells with cross time data
    table.cell(macd_table, 0, row, text=not na(cross_time) ? cross_time : "N/A", bgcolor=cross_color, text_color=color.white)  // Cross Time column, color applied from Cross Over/Under logic

// Populate table rows for each timeframe
add_row("1m", cross_time_1m, cross_type_1m, macd_value_1m, 1)
add_row("3m", cross_time_3m, cross_type_3m, macd_value_3m, 2)
add_row("5m", cross_time_5m, cross_type_5m, macd_value_5m, 3)
add_row("15m", cross_time_15m, cross_type_15m, macd_value_15m, 4)
add_row("1h", cross_time_1h, cross_type_1h, macd_value_1h, 5)
add_row("1d", cross_time_1d, cross_type_1d, macd_value_1d, 6)
