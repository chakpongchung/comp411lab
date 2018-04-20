.data
	abc:	.word 1, 3, 5
	def:	.word 2, 4, 6
	
	
.text
	la		$t2, abc
	la		$t2, 0xffff
	la		$t1, def($t2)
	la		$t1, ($t2)
	la		$t1, def+100($0)
	lw		$v1, def($t1)
	la		$v1, 0x546789AB($2)
	lui		$v1, 0xffff