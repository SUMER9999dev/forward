local catrom = script.Parent.Parent:FindFirstChild('catrom')
assert(catrom, 'Failed to get catrom dependency.')
return require(catrom)
