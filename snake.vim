function! Draw(width, height, x, y, fruitx, fruity)
	for i in range(a:height)
		echo ''
		for j in range(a:width)
			if i ==# 0 && j ==# 0
				echon '╭'
			elseif i ==# 0 && j ==# a:width - 1
				echon '╮'
			elseif i ==# a:height - 1 && j ==# 0
				echon '╰'
			elseif i ==# a:height - 1 && j ==# a:width - 1
				echon '╯'
			elseif i ==# 0 || i ==# a:height - 1
				echon '─'
			elseif j ==# 0 || j ==# a:width - 1
				echon '│'
			else
				if len(a:x) !=# len(a:y)
					echo 'Something wrong with length'
					return
				endif
				let l:broke = v:false
				for item_ind in range(len(a:x))
					if a:x[item_ind] ==# j && a:y[item_ind] ==# i
						echon item_ind%10
						let l:broke = v:true
						break
					endif
				endfor
				if !l:broke
					if i == a:fruity && j == a:fruitx
						echon '*'
					else
						echon ' '
					endif
				endif
			endif
		endfor
	endfor
endfunction

function! NewFruit(width, height, x, y)
	let l:broke = v:false
	while !l:broke
		let l:broke = v:true
		let l:fruitx = rand()%(a:width-2)+1
		let l:fruity = rand()%(a:height-2)+1
		echo "NewFruit is: x=".l:fruitx." y=".l:fruity
		for item_ind in range(len(a:x))
			if a:x[item_ind] ==# l:fruitx && a:y[item_ind] ==# l:fruity
				let l:broke = v:false
				break
			endif
		endfor
	endwhile
	return [l:fruitx, l:fruity]
endfunction
function! Game(width, height)
	let l:gameover = v:false
	let l:gamewon = v:false
	let l:x = [rand()%(a:width-2)+1]
	let l:y = [rand()%(a:height-2)+1]
	let [l:fruitx, l:fruity] = NewFruit(a:width, a:height, l:x, l:y)
	let l:score = 0
	let l:atefruit = v:false

	call Draw(a:width, a:height, l:x, l:y, l:fruitx, l:fruity)

	while !l:gameover && !l:gamewon
		let l:user_input = input('>')
		normal! :!echo
		if l:user_input ==# 'h'
			call add(l:x, l:x[-1]-1)
			call add(l:y, l:y[-1])
		elseif l:user_input ==# 'j'
			call add(l:y, l:y[-1]+1)
			call add(l:x, l:x[-1])
		elseif l:user_input ==# 'l'
			call add(l:x, l:x[-1]+1)
			call add(l:y, l:y[-1])
		elseif l:user_input ==# 'j'
		elseif l:user_input ==# 'k'
			call add(l:y, l:y[-1]-1)
			call add(l:x, l:x[-1])
		elseif l:user_input ==# 'x'
			let l:gameover = v:true
		else
			echo 'Unknown move: '.l:user_input
		endif
		if index(['h','j','k','l'], l:user_input) >=# 0 && !l:atefruit
			call remove(l:x, 0)
			call remove(l:y, 0)
		endif

		if l:x[-1] <# 1 || l:y[-1] <# 1 || l:x[-1] ># (a:width - 2) || l:y[-1] ># (a:height - 2)
			let l:gameover = v:true
		endif

		let l:atefruit = v:false
		if l:x[-1] ==# l:fruitx && l:y[-1] ==# l:fruity
			let l:score += 1
			let l:atefruit = v:true
			if len(l:x) ==# (a:width-2) * (a:height-2)
				let l:gamewon = v:true
			else
				let [l:fruitx, l:fruity] = NewFruit(a:width, a:height, l:x, l:y)
			endif
		endif

		echo 'fruitx: '.l:fruitx
		echo 'fruity: '.l:fruity
		echo 'Score: '.l:score
		call Draw(a:width, a:height, l:x, l:y, l:fruitx, l:fruity)
	endwhile

	if l:gamewon
		echo 'Game won'
	else
		echo 'Game over'
	endif
endfunction

function! Snake()
	echo 'Welcome to Snake game in Vim/NeoVim'
	let l:width = input('Your width: ')
	let l:height = input('Your height: ')

	echo ' '

	call Game(l:width, l:height)
endfunction
