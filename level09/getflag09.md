provided binary reads its first argument, add to each char its index and prints res.
we decided to substract index from each char in token file:
```
elements = ['f', '4', 'k', 'm', 'm', '6', 'p', '|', '=', '130', '127', 'p', '130', 'n', '131', '130', 'D', 'B', '131', 'D', 'u', '{', '127', '140', '137']

result_chars = []
print("Index | Element | Value | Value-Index | ASCII Char")
print("-" * 55)

for index, element in enumerate(elements):
    # Check if element is a multi-digit number
    if element.isdigit():
        value = int(element)
    else:
        # Single character - get ASCII value
        value = ord(element)
    
    # Subtract index from value
    new_value = value - index
    
    # Convert to ASCII character
    result_char = chr(new_value)
    result_chars.append(result_char)
    
    print(f"{index:5d} | {element:7s} | {value:5d} | {new_value:11d} | {result_char}")

print("\n" + "="*55)
print("Decoded message:")
decoded = ''.join(result_chars)
print(decoded)
print("\n" + "="*55)

```

non-printable characters we changed on its value-index 