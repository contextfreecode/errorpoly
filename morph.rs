fn main() {
    #[rustfmt::skip]
    let entries = vec![
        vec!["yes", "no", "yes"],
        vec!["yes", "no", "maybe"],
    ];
    for entry in entries {
        match binarize(&entry) {
            Ok(text) => println!("{text}"),
            Err(_) => println!("bad token"),
        }
    }
}

struct BadToken {}

fn binarize<T>(tokens: &[T]) -> Result<String, BadToken>
where
    T: AsRef<str>,
{
    map_join(tokens, |token| match token.as_ref() {
        "yes" => Ok("1"),
        "no" => Ok("0"),
        _ => Err(BadToken {}),
    })
}

fn map_join<T, F, S, E>(items: &[T], f: F) -> Result<String, E>
where
    F: Fn(&T) -> Result<S, E>,
    S: ToString,
{
    let mut out = String::new();
    for item in items {
        out.push_str(&f(item)?.to_string());
    }
    Ok(out)
}
