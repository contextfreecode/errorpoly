import java.util.List;
// import java.util.Collection;
// import java.util.stream.Collectors;

public class Morph {
    public static void main(String[] args) throws Exception {
        var entries = List.of(
                List.of("yes", "no", "yes"),
                List.of("yes", "no", "maybe"));
        for (var entry : entries) {
            System.out.println(binarize(entry));
        }
    }

    public static String binarize(
            Iterable<String> tokens) throws BadTokenException {
        return mapJoin(tokens, token -> {
            return switch (token) {
                case "yes" -> "1";
                case "no" -> "0";
                default -> throw new BadTokenException();
            };
        });
    }

    public interface Fun<A, B, E extends Throwable> {
        B apply(A a) throws E;
    }

    public static <T, E extends Throwable> String mapJoin(
            Iterable<T> items, Fun<T, String, E> fun) throws E {
        var builder = new StringBuilder();
        for (var item : items) {
            builder.append(fun.apply(item));
        }
        return builder.toString();
    }

    // public static <T, E extends Throwable> String mapJoinSad(
    //         Collection<T> items, Fun<T, String, E> fun) throws E {
    //     return items.stream()
    //             .map(item -> fun.apply(item))
    //             .collect(Collectors.joining());
    // }

    public static class BadTokenException extends Exception {
        public BadTokenException() {
            super();
        }
    }
}
