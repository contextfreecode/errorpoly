import java.util.Collection;
import java.util.List;
import java.util.stream.Collectors;

public class Morph {
    public static void main(String[] args) throws Exception {
        var entries = List.of(
                List.of("yes", "no", "yes"),
                List.of("yes", "no", "maybe"));
        for (var entry : entries) {
            System.out.println(binarize(entry));
        }
    }

    public static class BadTokenException extends Exception {
    }

    public static String binarize(
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

    public interface Fun<A, B, E extends Exception> {
        B apply(A a) throws E;
    }

    public static <T, E extends Exception> String mapJoin(
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

    public static String binarizeBetter(
            Collection<String> tokens) throws BadTokenException {
        return mapJoinBetter(tokens, token -> {
            return switch (token) {
                case "yes" -> "1";
                case "no" -> "0";
                default -> throw new BadTokenException();
            };
        });
    }

    public static <T, E extends Exception> String mapJoinBetter(
            Collection<T> items, Fun<T, String, E> fun) throws E {
        var builder = new StringBuilder();
        for (var item : items) {
            builder.append(fun.apply(item));
        }
        return builder.toString();
    }
}
