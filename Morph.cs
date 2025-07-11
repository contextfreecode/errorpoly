static class Morph
{
    static void Main()
    {
        var entries = new List<List<string>>
        {
            new List<string> { "yes", "no", "yes" },
            new List<string> { "yes", "no", "maybe" },
        };
        foreach (var entry in entries)
        {
            try
            {
                Console.WriteLine(Binarize(entry));
            }
            catch (BadTokenException)
            {
                Console.WriteLine("bad token");
            }
        }
    }

    static string Binarize(IEnumerable<string> tokens)
    {
        return tokens.MapJoin(tokens =>
        {
            return tokens switch
            {
                "yes" => "1",
                "no" => "0",
                _ => throw new BadTokenException(),
            };
        });
    }

    static string MapJoin<T>(this IEnumerable<T> items, Func<T, string> func)
    {
        return string.Concat(items.Select(func));
    }
}

class BadTokenException : Exception { }
