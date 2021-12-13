f = open("aoc-1-1.txt", "r")
i = f.readlines()

total_increasing_deltas = 0
last = int(i[0])

for depth in i[1:]:
	if int(depth) > last:
		total_increasing_deltas += 1
	last = int(depth)

print(last)
print(total_increasing_deltas)
