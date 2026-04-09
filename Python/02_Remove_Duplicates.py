def remove_duplicates(input_string):
    result = ""
    for char in input_string:
        if char not in result:
            result += char
    return result


# Test cases
test_strings = [
    "programming",
    "hello world",
    "aabbccdd",
    "PlatinumRx",
    "mississippi"
]

for s in test_strings:
    print(f'Input:  "{s}"')
    print(f'Output: "{remove_duplicates(s)}"')
    print()
