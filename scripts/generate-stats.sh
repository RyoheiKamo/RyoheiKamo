```bash
#!/bin/bash

set -e

OUTPUT="stats/language-stats.md"

mkdir -p stats

cat > "$OUTPUT" << 'EOF'
## Language Stats

| Language | Files | Code |
|---|---:|---:|
EOF

awk -F',' '
BEGIN {
    php_files = php_code = 0
    go_files = go_code = 0
    rust_files = rust_code = 0
    ts_files = ts_code = 0
    js_files = js_code = 0
    python_files = python_code = 0
}

NR > 1 {
    language = $2
    files = $1
    code = $5

    if (language == "PHP") {
        php_files += files
        php_code += code
    }
    else if (language == "Go") {
        go_files += files
        go_code += code
    }
    else if (language == "Rust") {
        rust_files += files
        rust_code += code
    }
    else if (language == "TypeScript" || language == "TypeScript JSX") {
        ts_files += files
        ts_code += code
    }
    else if (language == "JavaScript" || language == "JavaScript JSX") {
        js_files += files
        js_code += code
    }
    else if (language == "Python") {
        python_files += files
        python_code += code
    }
}

END {
    if (php_files > 0)
        printf "| PHP | %d | %d |\n", php_files, php_code

    if (go_files > 0)
        printf "| Go | %d | %d |\n", go_files, go_code

    if (rust_files > 0)
        printf "| Rust | %d | %d |\n", rust_files, rust_code

    if (ts_files > 0)
        printf "| TypeScript | %d | %d |\n", ts_files, ts_code

    if (js_files > 0)
        printf "| JavaScript | %d | %d |\n", js_files, js_code

    if (python_files > 0)
        printf "| Python | %d | %d |\n", python_files, python_code
}
' cloc.csv >> "$OUTPUT"

python3 << 'PY'
from pathlib import Path

readme = Path("README.md")
stats = Path("stats/language-stats.md").read_text()

text = readme.read_text()

start = "<!-- LEARNING_STATS_START -->"
end = "<!-- LEARNING_STATS_END -->"

before, rest = text.split(start, 1)
_, after = rest.split(end, 1)

new_text = (
    before
    + start
    + "\n\n"
    + stats.strip()
    + "\n\n"
    + end
    + after
)

readme.write_text(new_text)
PY
```
