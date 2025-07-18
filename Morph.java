import java.util.Collection;
import java.util.List;
import java.util.stream.Collectors;

class Morph {
    public static void main(String[] args) {
        var entries = List.of(
                List.of("yes", "no", "yes"),
                List.of("yes", "no", "maybe"));
        for (var entry : entries) {
            try {
                System.out.println(binarize(entry));
            } catch (BadTokenException e) {
                System.out.println("bad token");
            }
        }
    }

    static class BadTokenException extends Exception {
    }

    static String binarize(
            Collection<String> tokens) throws BadTokenException {
        try {
            return mapJoin(tokens, token -> {
                return switch (token) {
                    case "yes" -> "1";
                    case "no" -> "0";
                    default -> throw new BadTokenException();
                };
            });
        } catch (RuntimeException e) {
            switch (e.getCause()) {
                case BadTokenException b -> throw b;
                default -> throw e;
            }
        }
    }

    interface Fun<A, B, E extends Exception> {
        B apply(A a) throws E;
    }

    static <T, E extends Exception> String mapJoin(
            Collection<T> items, Fun<T, String, E> fun) throws E {
        return items.stream()
                .map(item -> {
                    try {
                        return fun.apply(item);
                    } catch (Exception e) {
                        throw new RuntimeException(e);
                    }
                })
                .collect(Collectors.joining());
    }

    static String binarizeBetter(
            Collection<String> tokens) throws BadTokenException {
        return mapJoinBetter(tokens, token -> {
            return switch (token) {
                case "yes" -> "1";
                case "no" -> "0";
                default -> throw new BadTokenException();
            };
        });
    }

    static <T, E extends Exception> String mapJoinBetter(
            Collection<T> items, Fun<T, String, E> fun) throws E {
        var builder = new StringBuilder();
        for (var item : items) {
            builder.append(fun.apply(item));
        }
        return builder.toString();
    }
}
