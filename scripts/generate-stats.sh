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
    allowed["PHP"] = 1
    allowed["Go"] = 1
    allowed["Rust"] = 1
    allowed["TypeScript"] = 1
    allowed["JavaScript"] = 1
    allowed["Python"] = 1
}
NR > 1 && allowed[$2] {
    printf "| %s | %s | %s |\n", $2, $1, $5
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
