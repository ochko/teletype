return enum_for(:doc) unless block_given?

yield %|usage: rougify {global options} [command] [args...]|
yield %||
yield %|where <command> is one of:|
yield %|	highlight	#{Highlight.desc}|
yield %|	debug		#{Debug.desc}|
yield %|	help		#{Help.desc}|
yield %|	style		#{Style.desc}|
yield %|	list		#{List.desc}|
yield %|	guess		#{Guess.desc}|
yield %|	version		#{Version.desc}|
yield %||
yield %|global options:|
yield %[	--require|-r <fname>	require <fname> after loading rouge]
yield %||
yield %|See `rougify help <command>` for more info.|
