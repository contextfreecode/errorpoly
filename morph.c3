import std::io;

faultdef BAD_TOKEN;

fn void main()
{
	String[][] entries = { { "yes", "no", "yes"   },
	                       { "yes", "no", "maybe" } };
	foreach (entry : entries)
	{
		if (catch err = io::printn(binarize(entry)))
		{
			if (err != BAD_TOKEN) err?!!; // This should not happen, so panic if it does.
			io::printn("bad token");
		}
	}
}

// This macro can be made to be more generic and for example return a List{...} 
// by inferring the result, as well as providing flexibility for 
// memory handling.
macro @map_join(items, #func, ...)
{
	DString str;
	foreach (item : items)
	{
		$if $defined(#func(item, $vasplat)!):
			str.append(#func(item, $vasplat))!;
		$else
			str.append(#func(item, $vasplat));
		$endif
	}
	return str.str_view();
}

fn String? binarize(String[] tokens)
{
	return @map_join(tokens, fn String?(String s) {
		switch (s)
		{
			case "yes": return "1";
			case "no": return "0";
			default: return BAD_TOKEN?;
		}
	});
}
