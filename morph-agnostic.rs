use std::fmt::Debug;

fn main() {
    #[rustfmt::skip]
    let entries = vec![
        vec!["yes", "no", "yes"],
        vec!["yes", "no", "maybe"],
    ];
    for entry in entries {
        let text = binarize(&entry);
        println!("{text}");
    }
}

#[derive(Debug)]
struct BadToken {}

fn binarize<T>(tokens: &[T]) -> String
where
    T: AsRef<str>,
{
    map_join(tokens, |token| match token.as_ref() {
        "yes" => Ok("1"),
        "no" => Ok("0"),
        _ => Err(BadToken {}),
    })
}

fn map_join<T, F, R>(items: &[T], f: F) -> String
where
    F: Fn(&T) -> R,
    R: Debug,
{
    items.iter().fold(String::new(), |mut text, item| {
        text.push_str(format!("{:?}", f(item)).as_str());
        text
    })
}
