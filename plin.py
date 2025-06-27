n = 3
total = 3
while 1:
    for x in range(1, total - 2 + 1, 1):
        for y in range(1, total - x - 1 + 1, 1):
            z = total - x - y
            if x ** n + y ** n == z ** n:
                print("hola, mundo")
    total = total + 1
