function! Donut()
	let l:A = 0.0
	let l:B = 0.0
	call printf("\<esc>[2J]")
	while v:true
		let l:b = ''
		let l:z = []
		for index in range(0, 1760)
			let l:b .= nr2char(32)
		endfor
		for index in range(0, 1760)
			call add(l:z, 0)
		endfor
		let l:j = 0
		while 6.28 > l:j
			let l:i = 0
			while 6.28 > l:i
				let l:c = sin(l:i)
				let l:d = cos(l:j)
				let l:e = sin(l:A)
				let l:f = sin(l:j)
				let l:g = cos(l:A)
				let l:h = l:d + 2
				let l:D = 1/(l:c*l:h*l:e+l:f*l:g+5)
				let l:l = cos(l:i)
				let l:m = cos(l:B)
				let l:n = sin(l:B)
				let l:t = l:c*l:h*l:g-l:f*l:e
				let l:x = float2nr(40+30*l:D*(l:l*l:h*l:m-l:t*l:n))
				let l:y = float2nr(12+15*l:D*(l:l*l:h*l:n+l:t*l:m))
				let l:o = float2nr(l:x+80*l:y)
				let l:N = float2nr(8*((l:f*l:e-l:c*l:d*l:g)*l:m-l:c*l:d*l:e-l:f*l:g-l:l*l:d*l:n))
				if 22>l:y&&l:y>0&&l:x>0&&80>l:x&&l:z[l:o]<=l:D
					"let l:z[l:o] = l:D
					let l:z[l:o] = l:D
					let l:w='.,-~:;=!*#$@'[l:N>0?l:N:0]
					let l:b=l:b[0:l:o].l:w.l:b[l:o+2:]
				endif
				let l:i += 0.02
			endwhile
			let l:j += 0.5
		endwhile
		echo printf("\<esc>[H")
		let l:k = 0
		while 1761 ># l:k
			if l:k % 80 > 0
				echon l:b[l:k]
			else
				echo ''
			endif
			let l:k += 1
		endwhile
		let l:A += 0.16
		let l:B += 0.08
	endwhile
endfunction
