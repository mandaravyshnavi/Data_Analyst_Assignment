def convert_minutes(total_minutes):
    hours = total_minutes // 60
    minutes = total_minutes % 60

    if hours == 0:
        return f"{minutes} minutes"
    elif minutes == 0:
        return f"{hours} hrs"
    else:
        return f"{hours} hrs {minutes} minutes"


# Test cases
test_cases = [130, 110, 60, 45, 200, 0]
for mins in test_cases:
    print(f"{mins} -> \"{convert_minutes(mins)}\"")
