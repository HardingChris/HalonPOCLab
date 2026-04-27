# Copilot Instructions

## Halon / HSL Safety Rules

- Use Halon HSL operator keywords, not C-style operators.
- For boolean logic in HSL, use `and`, `or`, and `not`.
- Do not use `&&`, `||`, or `!` in HSL hook scripts.
- Use existing repository style for HSL conditionals and arrays.

## Queue Hook Rules

- In postdelivery hooks, always guard action-dependent logic with `isset($arguments["action"])` before checking `$arguments["action"]`.
- Keep recipient-specific behavior explicitly scoped with `$message["recipient"] == "..."` when requested.
- When changing bounce behavior, prefer minimal, single-responsibility edits and preserve existing logging.

## Validation Before Finishing

- After any edit to files under `src/hooks/`, run `halonconfig` and ensure it succeeds.
- If `halonconfig` fails, fix syntax/runtime issues before returning results.
- Include the exact parser error line/column in the response when a validation failure occurs.

## Halon Product Documentation Sources

The following web pages contain the official documentation for Halon products and should be used as primary references when writing or editing HSL hook scripts or halon yaml configuration files:
- [Halon SMTPD Documentation](https://docs.halon.io/manual/)
- [Halon HSL Documentation](https://docs.halon.io/hsl/)
- [Halon Web Documentation](https://docs.halon.io/web/)
- [Halon MSUI Documentation](https://docs.halon.io/msui/)
- [Halon DLPD Documentation](https://docs.halon.io/dlpd/)
- [Halon clusterd Documentation](https://docs.halon.io/clusterd/)
- [Halon protect and engage knowledge base](https://docs.halon.io/kb/)
- [Halon dlp() function documentation](https://github.com/halon-extras/dlp/blob/main/README.md)

