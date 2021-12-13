f = open("aoc-1-1.txt", "r")
i = f.readlines()

i = [int(depth) for depth in i]
total_increasing_deltas = 0
last_three = i[:3]

for depth in i[3:]:
	new_last_three = [last_three[1], last_three[2], depth]
	if sum(new_last_three) > sum(last_three):
		total_increasing_deltas += 1
	last_three = new_last_three

print(total_increasing_deltas)
