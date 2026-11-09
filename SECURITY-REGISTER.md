# Security policy and finding register

Owner for every row: domyusuf. Revisit date for accepted risks: 2026-11-16.
Scan date: 2026-11-09. Findings are per package and vulnerability, not unique CVE counts.

## Enforced policy

- Gitleaks blocks every detected secret and scans full Git history in CI.
- Bandit blocks all application findings, including LOW severity. This small app has no remaining finding that needs an exception.
- Trivy prints HIGH and CRITICAL findings and blocks CRITICAL findings with a published fix. Unfixed CRITICAL and HIGH findings require a register entry and review.
- Checkov blocks all Terraform findings. No checks are suppressed.

CI runs Gitleaks because local hooks can be skipped or never installed. The local
hook scans the staged change, while CI checks the full history. Bandit detects
hardcoded password assignments, including Django's development placeholder.
Gitleaks uses credential patterns and entropy rules and deliberately allows that
placeholder. The tools cover different failure modes.

## Observed evidence

- The initial configuration commit passed Gitleaks; Ruff skipped because no Python was staged.
- A temporary, freshly generated 64-character hex value assigned to SECRET_KEY was rejected by the hook with exit code 1 and generic-api-key. It was restored and never committed.
- [Baseline PR scan](https://github.com/domyusuf/devops-2025S-demo/actions/runs/42584375839) reported B105 and CKV_AWS_136.
- [Remediated code and IaC scan; image baseline](https://github.com/domyusuf/devops-2025S-demo/actions/runs/42584643940) passed Bandit, Gitleaks and Checkov and reported 56 HIGH plus 1 CRITICAL image findings.
- [Enforced image gate before dependency fixes](https://github.com/domyusuf/devops-2025S-demo/actions/runs/42584720946) failed on the fixable CRITICAL Django CVE.
- Initial scanner installation downloads failed (HTTP 504 for Gitleaks and a failed Trivy binary download). CI now runs published, versioned scanner containers. Download failures fail the job.
- The upstream linting workflow was empty and invalid. It now runs Ruff.

## Code and infrastructure findings

| Finding | Location | Disposition and justification |
|---|---|---|
| B105, LOW | campus_notifier/settings.py | Remediate. Require DJANGO_SECRET_KEY from the runtime environment. Local .env is ignored by Git and Docker. The old development placeholder remains in history. Removing it from the file does not rotate it; deployments must generate their own new key. |
| CKV_AWS_136 | terraform/main.tf, aws_ecr_repository.devops_repo | Remediate. Explicitly configure KMS encryption. This PR changes configuration only; no AWS infrastructure was applied. |

## Image baseline findings

Django was upgraded from 5.2.7 to 5.2.17. The Dockerfile installs the published
Debian zlib security update. Remaining HIGH findings without a vendor fix are
accepted for this classroom image until the revisit date, with no scanner
suppression. Rebuild with the patched base packages when Debian publishes fixes.
This acceptance does not authorize using the image for sensitive production data.

| CVE | Package | Installed baseline | Severity | Published fix | Disposition / remedy |
|---|---|---|---|---|---|
| CVE-2026-76642 | bsdutils | 1:2.41.5-0+deb13u1 | HIGH | Unavailable | Accept until 2026-11-16; owner domyusuf. Vendor fix unavailable. Rebuild when a Debian security update is published. |
| CVE-2026-78408 | bsdutils | 1:2.41.5-0+deb13u1 | HIGH | Unavailable | Accept until 2026-11-16; owner domyusuf. Vendor fix unavailable. Rebuild when a Debian security update is published. |
| CVE-2026-78409 | bsdutils | 1:2.41.5-0+deb13u1 | HIGH | Unavailable | Accept until 2026-11-16; owner domyusuf. Vendor fix unavailable. Rebuild when a Debian security update is published. |
| CVE-2026-78410 | bsdutils | 1:2.41.5-0+deb13u1 | HIGH | Unavailable | Accept until 2026-11-16; owner domyusuf. Vendor fix unavailable. Rebuild when a Debian security update is published. |
| CVE-2026-54369 | libacl1 | 2.3.2-2+b1 | HIGH | Unavailable | Accept until 2026-11-16; owner domyusuf. Vendor fix unavailable. Rebuild when a Debian security update is published. |
| CVE-2026-76642 | libblkid1 | 2.41.5-0+deb13u1 | HIGH | Unavailable | Accept until 2026-11-16; owner domyusuf. Vendor fix unavailable. Rebuild when a Debian security update is published. |
| CVE-2026-78408 | libblkid1 | 2.41.5-0+deb13u1 | HIGH | Unavailable | Accept until 2026-11-16; owner domyusuf. Vendor fix unavailable. Rebuild when a Debian security update is published. |
| CVE-2026-78409 | libblkid1 | 2.41.5-0+deb13u1 | HIGH | Unavailable | Accept until 2026-11-16; owner domyusuf. Vendor fix unavailable. Rebuild when a Debian security update is published. |
| CVE-2026-78410 | libblkid1 | 2.41.5-0+deb13u1 | HIGH | Unavailable | Accept until 2026-11-16; owner domyusuf. Vendor fix unavailable. Rebuild when a Debian security update is published. |
| CVE-2026-76642 | liblastlog2-2 | 2.41.5-0+deb13u1 | HIGH | Unavailable | Accept until 2026-11-16; owner domyusuf. Vendor fix unavailable. Rebuild when a Debian security update is published. |
| CVE-2026-78408 | liblastlog2-2 | 2.41.5-0+deb13u1 | HIGH | Unavailable | Accept until 2026-11-16; owner domyusuf. Vendor fix unavailable. Rebuild when a Debian security update is published. |
| CVE-2026-78409 | liblastlog2-2 | 2.41.5-0+deb13u1 | HIGH | Unavailable | Accept until 2026-11-16; owner domyusuf. Vendor fix unavailable. Rebuild when a Debian security update is published. |
| CVE-2026-78410 | liblastlog2-2 | 2.41.5-0+deb13u1 | HIGH | Unavailable | Accept until 2026-11-16; owner domyusuf. Vendor fix unavailable. Rebuild when a Debian security update is published. |
| CVE-2026-76642 | libmount1 | 2.41.5-0+deb13u1 | HIGH | Unavailable | Accept until 2026-11-16; owner domyusuf. Vendor fix unavailable. Rebuild when a Debian security update is published. |
| CVE-2026-78408 | libmount1 | 2.41.5-0+deb13u1 | HIGH | Unavailable | Accept until 2026-11-16; owner domyusuf. Vendor fix unavailable. Rebuild when a Debian security update is published. |
| CVE-2026-78409 | libmount1 | 2.41.5-0+deb13u1 | HIGH | Unavailable | Accept until 2026-11-16; owner domyusuf. Vendor fix unavailable. Rebuild when a Debian security update is published. |
| CVE-2026-78410 | libmount1 | 2.41.5-0+deb13u1 | HIGH | Unavailable | Accept until 2026-11-16; owner domyusuf. Vendor fix unavailable. Rebuild when a Debian security update is published. |
| CVE-2025-69720 | libncursesw6 | 6.5+20250216-2 | HIGH | Unavailable | Accept until 2026-11-16; owner domyusuf. Vendor fix unavailable. Rebuild when a Debian security update is published. |
| CVE-2026-76642 | libsmartcols1 | 2.41.5-0+deb13u1 | HIGH | Unavailable | Accept until 2026-11-16; owner domyusuf. Vendor fix unavailable. Rebuild when a Debian security update is published. |
| CVE-2026-78408 | libsmartcols1 | 2.41.5-0+deb13u1 | HIGH | Unavailable | Accept until 2026-11-16; owner domyusuf. Vendor fix unavailable. Rebuild when a Debian security update is published. |
| CVE-2026-78409 | libsmartcols1 | 2.41.5-0+deb13u1 | HIGH | Unavailable | Accept until 2026-11-16; owner domyusuf. Vendor fix unavailable. Rebuild when a Debian security update is published. |
| CVE-2026-78410 | libsmartcols1 | 2.41.5-0+deb13u1 | HIGH | Unavailable | Accept until 2026-11-16; owner domyusuf. Vendor fix unavailable. Rebuild when a Debian security update is published. |
| CVE-2026-119373 | libsqlite3-0 | 3.46.1-7+deb13u2 | HIGH | Unavailable | Accept until 2026-11-16; owner domyusuf. Vendor fix unavailable. Rebuild when a Debian security update is published. |
| CVE-2026-119374 | libsqlite3-0 | 3.46.1-7+deb13u2 | HIGH | Unavailable | Accept until 2026-11-16; owner domyusuf. Vendor fix unavailable. Rebuild when a Debian security update is published. |
| CVE-2026-119379 | libsqlite3-0 | 3.46.1-7+deb13u2 | HIGH | Unavailable | Accept until 2026-11-16; owner domyusuf. Vendor fix unavailable. Rebuild when a Debian security update is published. |
| CVE-2026-16742 | libsystemd0 | 257.13-1~deb13u1 | HIGH | Unavailable | Accept until 2026-11-16; owner domyusuf. Vendor fix unavailable. Rebuild when a Debian security update is published. |
| CVE-2025-69720 | libtinfo6 | 6.5+20250216-2 | HIGH | Unavailable | Accept until 2026-11-16; owner domyusuf. Vendor fix unavailable. Rebuild when a Debian security update is published. |
| CVE-2026-16742 | libudev1 | 257.13-1~deb13u1 | HIGH | Unavailable | Accept until 2026-11-16; owner domyusuf. Vendor fix unavailable. Rebuild when a Debian security update is published. |
| CVE-2026-76642 | libuuid1 | 2.41.5-0+deb13u1 | HIGH | Unavailable | Accept until 2026-11-16; owner domyusuf. Vendor fix unavailable. Rebuild when a Debian security update is published. |
| CVE-2026-78408 | libuuid1 | 2.41.5-0+deb13u1 | HIGH | Unavailable | Accept until 2026-11-16; owner domyusuf. Vendor fix unavailable. Rebuild when a Debian security update is published. |
| CVE-2026-78409 | libuuid1 | 2.41.5-0+deb13u1 | HIGH | Unavailable | Accept until 2026-11-16; owner domyusuf. Vendor fix unavailable. Rebuild when a Debian security update is published. |
| CVE-2026-78410 | libuuid1 | 2.41.5-0+deb13u1 | HIGH | Unavailable | Accept until 2026-11-16; owner domyusuf. Vendor fix unavailable. Rebuild when a Debian security update is published. |
| CVE-2026-76642 | login | 1:4.16.0-2+really2.41.5-0+deb13u1 | HIGH | Unavailable | Accept until 2026-11-16; owner domyusuf. Vendor fix unavailable. Rebuild when a Debian security update is published. |
| CVE-2026-78408 | login | 1:4.16.0-2+really2.41.5-0+deb13u1 | HIGH | Unavailable | Accept until 2026-11-16; owner domyusuf. Vendor fix unavailable. Rebuild when a Debian security update is published. |
| CVE-2026-78409 | login | 1:4.16.0-2+really2.41.5-0+deb13u1 | HIGH | Unavailable | Accept until 2026-11-16; owner domyusuf. Vendor fix unavailable. Rebuild when a Debian security update is published. |
| CVE-2026-78410 | login | 1:4.16.0-2+really2.41.5-0+deb13u1 | HIGH | Unavailable | Accept until 2026-11-16; owner domyusuf. Vendor fix unavailable. Rebuild when a Debian security update is published. |
| CVE-2026-76642 | mount | 2.41.5-0+deb13u1 | HIGH | Unavailable | Accept until 2026-11-16; owner domyusuf. Vendor fix unavailable. Rebuild when a Debian security update is published. |
| CVE-2026-78408 | mount | 2.41.5-0+deb13u1 | HIGH | Unavailable | Accept until 2026-11-16; owner domyusuf. Vendor fix unavailable. Rebuild when a Debian security update is published. |
| CVE-2026-78409 | mount | 2.41.5-0+deb13u1 | HIGH | Unavailable | Accept until 2026-11-16; owner domyusuf. Vendor fix unavailable. Rebuild when a Debian security update is published. |
| CVE-2026-78410 | mount | 2.41.5-0+deb13u1 | HIGH | Unavailable | Accept until 2026-11-16; owner domyusuf. Vendor fix unavailable. Rebuild when a Debian security update is published. |
| CVE-2025-69720 | ncurses-base | 6.5+20250216-2 | HIGH | Unavailable | Accept until 2026-11-16; owner domyusuf. Vendor fix unavailable. Rebuild when a Debian security update is published. |
| CVE-2025-69720 | ncurses-bin | 6.5+20250216-2 | HIGH | Unavailable | Accept until 2026-11-16; owner domyusuf. Vendor fix unavailable. Rebuild when a Debian security update is published. |
| CVE-2026-9538 | perl-base | 5.40.1-6+deb13u1 | HIGH | Unavailable | Accept until 2026-11-16; owner domyusuf. Vendor fix unavailable. Rebuild when a Debian security update is published. |
| CVE-2026-76642 | util-linux | 2.41.5-0+deb13u1 | HIGH | Unavailable | Accept until 2026-11-16; owner domyusuf. Vendor fix unavailable. Rebuild when a Debian security update is published. |
| CVE-2026-78408 | util-linux | 2.41.5-0+deb13u1 | HIGH | Unavailable | Accept until 2026-11-16; owner domyusuf. Vendor fix unavailable. Rebuild when a Debian security update is published. |
| CVE-2026-78409 | util-linux | 2.41.5-0+deb13u1 | HIGH | Unavailable | Accept until 2026-11-16; owner domyusuf. Vendor fix unavailable. Rebuild when a Debian security update is published. |
| CVE-2026-78410 | util-linux | 2.41.5-0+deb13u1 | HIGH | Unavailable | Accept until 2026-11-16; owner domyusuf. Vendor fix unavailable. Rebuild when a Debian security update is published. |
| CVE-2026-76844 | zlib1g | 1:1.3.dfsg+really1.3.1-1+b1 | HIGH | 1:1.3.dfsg+really1.3.1-1+deb13u1 | Remediate by installing the Debian zlib update during build. |
| CVE-2026-85091 | zlib1g | 1:1.3.dfsg+really1.3.1-1+b1 | HIGH | 1:1.3.dfsg+really1.3.1-1+deb13u1 | Remediate by installing the Debian zlib update during build. |
| CVE-2025-64459 | Django | 5.2.7 | CRITICAL | 5.2.8, 5.1.14, 4.2.26 | Remediate by upgrading to Django 5.2.17. |
| CVE-2025-64458 | Django | 5.2.7 | HIGH | 5.2.8, 5.1.14, 4.2.26 | Remediate by upgrading to Django 5.2.17. |
| CVE-2026-1207 | Django | 5.2.7 | HIGH | 6.0.2, 5.2.11, 4.2.28 | Remediate by upgrading to Django 5.2.17. |
| CVE-2026-1287 | Django | 5.2.7 | HIGH | 6.0.2, 5.2.11, 4.2.28 | Remediate by upgrading to Django 5.2.17. |
| CVE-2026-15307 | Django | 5.2.7 | HIGH | 5.2.17, 6.0.8 | Remediate by upgrading to Django 5.2.17. |
| CVE-2026-25673 | Django | 5.2.7 | HIGH | 6.0.3, 5.2.12, 4.2.29 | Remediate by upgrading to Django 5.2.17. |
| CVE-2026-33034 | Django | 5.2.7 | HIGH | 6.0.4, 5.2.13, 4.2.30 | Remediate by upgrading to Django 5.2.17. |
| CVE-2026-3902 | Django | 5.2.7 | HIGH | 6.0.4, 5.2.13, 4.2.30 | Remediate by upgrading to Django 5.2.17. |

## Verified remediation result

The image report after the Django and zlib updates contains **47 HIGH and 0
CRITICAL** findings. All 47 remaining rows have no published fix in Trivy's report.
The eight Django findings and two zlib findings listed above are resolved.
The severity counts describe the scanned image at this date, not a permanent
guarantee. The workflow uploads the full machine-readable report on each run.
