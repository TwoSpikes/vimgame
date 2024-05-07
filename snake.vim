function! Draw(width, height, x, y, fruitx, fruity)
	silent normal! ggvG$d
	exec 'normal! oScore: '.g:score
	for i in range(a:height)
		normal! o
		for j in range(a:width)
			if i ==# 0 && j ==# 0
				normal! a╭
			elseif i ==# 0 && j ==# a:width - 1
				normal! a╮
			elseif i ==# a:height - 1 && j ==# 0
				normal! a╰
			elseif i ==# a:height - 1 && j ==# a:width - 1
				normal! a╯
			elseif i ==# 0 || i ==# a:height - 1
				normal! a─
			elseif j ==# 0 || j ==# a:width - 1
				normal! a│
			else
				if len(a:x) !=# len(a:y)
					echo 'Something wrong with length'
					return
				endif
				let l:broke = v:false
				for item_ind in range(len(a:x))
					if a:x[item_ind] ==# j && a:y[item_ind] ==# i
						exec 'normal! a'.item_ind%10
						let l:broke = v:true
						break
					endif
				endfor
				if !l:broke
					if i == a:fruity && j == a:fruitx
						normal! a*
					else
						normal! a 
					endif
				endif
			endif
		endfor
	endfor
	redraw
endfunction

function! NewFruit(width, height, x, y)
	let l:broke = v:false
	while !l:broke
		let l:broke = v:true
		let l:fruitx = rand()%(a:width-2)+1
		let l:fruity = rand()%(a:height-2)+1
		exec "normal! oNewFruit is: x=".l:fruitx." y=".l:fruity
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
	new
	setlocal buftype=nofile bufhidden=hide noswapfile nobuflisted
	let l:tick = 0
	let l:gameover = v:false
	let l:gamewon = v:false
	let l:x = [rand()%(a:width-2)+1]
	let l:y = [rand()%(a:height-2)+1]
	let [l:fruitx, l:fruity] = NewFruit(a:width, a:height, l:x, l:y)
	let g:score = 0
	let l:atefruit = v:false

	call Draw(a:width, a:height, l:x, l:y, l:fruitx, l:fruity)

	" 0 = none
	" 1 = left
	" 2 = down
	" 3 = right
	" 4 = up
	let l:dir = 0
	redraw
	while !l:gameover && !l:gamewon
		let l:tick += 1
		if (l:tick % 10000) ==# 0
			if l:dir ==# 0
			elseif l:dir ==# 1
				let to_add_x = l:x[-1]-1
				let to_add_y = l:y[-1]
			elseif l:dir ==# 2
				let to_add_y = l:y[-1]+1
				let to_add_x = l:x[-1]
			elseif l:dir ==# 3
				let to_add_x = l:x[-1]+1
				let to_add_y = l:y[-1]
			elseif l:dir ==# 4
				let to_add_y = l:y[-1]-1
				let to_add_x = l:x[-1]
			else
				echo "Internal error: l:dir = ".l:dir
				let l:dir = 0
			endif

			if l:dir !=# 0
				for i in range(len(l:x))
					if   l:x[i] ==# to_add_x
					\ && l:y[i] ==# to_add_y
						let l:gameover = v:true
						break
					endif
				endfor
				call add(l:x, to_add_x)
				call add(l:y, to_add_y)
			endif

			if l:dir !=# 0 && !l:atefruit
				call remove(l:x, 0)
				call remove(l:y, 0)
			endif

			if l:x[-1] <# 1 || l:y[-1] <# 1 || l:x[-1] ># (a:width - 2) || l:y[-1] ># (a:height - 2)
				let l:gameover = v:true
			endif

			let l:atefruit = v:false
			if l:x[-1] ==# l:fruitx && l:y[-1] ==# l:fruity
				let g:score += 1
				let l:atefruit = v:true
				if len(l:x) ==# (a:width-2) * (a:height-2)
					let l:gamewon = v:true
				else
					let [l:fruitx, l:fruity] = NewFruit(a:width, a:height, l:x, l:y)
				endif
			endif

			call Draw(a:width, a:height, l:x, l:y, l:fruitx, l:fruity)
		endif
		let l:user_input = nr2char(getchar(0))
		if l:user_input ==# 'h'
			let l:dir = 1
		elseif l:user_input ==# 'j'
			let l:dir = 2
		elseif l:user_input ==# 'l'
			let l:dir = 3
		elseif l:user_input ==# 'k'
			let l:dir = 4
		elseif l:user_input ==# 'x'
			let l:gameover = v:true
		elseif l:user_input ==# 'q'
			let l:gameover = v:true
		elseif l:user_input ==# nr2char(0)
		else
			echo 'Unknown move: '.l:user_input
		endif
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

	call Game(l:width, l:height)
endfunction
