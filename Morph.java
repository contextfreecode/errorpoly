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
            Collection<T> items, Fun<T, String, E> fun) throws E {
        try {
            return items.stream()
                    .map(item -> {
                        try {
                            return fun.apply(item);
                        } catch (Throwable e) {
                            throw new RuntimeException(e);
                        }
                    })
                    .collect(Collectors.joining());
        } catch (RuntimeException e) {
            var cause = e.getCause();
            if (cause instanceof Error) {
                throw (Error)cause;
            }
            throw e;
        }
    }

    public static <T, E extends Throwable> String mapJoinBetter(
            Collection<T> items, Fun<T, String, E> fun) throws E {
        var builder = new StringBuilder();
        for (var item : items) {
            builder.append(fun.apply(item));
        }
        return builder.toString();
    }
}
