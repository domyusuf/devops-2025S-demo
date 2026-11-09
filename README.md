# devops-2025S-demo
class demo for devops class
pretending to add more details to the readme
completed.

## Local configuration

Generate a development key in an ignored .env file before running Django:

```sh
python3 -c 'import secrets; from pathlib import Path; p = Path(".env"); p.touch(mode=0o600, exist_ok=True); p.write_text(p.read_text() + "\nDJANGO_SECRET_KEY=" + secrets.token_hex(32) + "\n")'
```

The key is required. Containers receive it at runtime with `docker run --env-file .env -p 8000:8000 campus-notifier:dev`.

## Security checks

Install `pre-commit` with pip, start Docker, and run `pre-commit install`.
Ruff checks staged Python and Gitleaks checks staged changes. CI separately scans
the full Git history, application code, built image, and Terraform. See
`SECURITY-REGISTER.md` for the enforced policy, findings, and evidence.
