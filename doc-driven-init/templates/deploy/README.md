# deploy/

Dev/deployment scaffolding for {{PROJECT_NAME}}.

## Files
- `docker-compose.dev.yml` — local dev stack. A parameterized skeleton with four common
  services (db, cache, backend, static web). **Keep only what you need; delete the rest.**
- `backend.Dockerfile` — backend image. Set the base image, dependency file, and start command
  for your stack.

## Usage
```bash
# Fill in the placeholders first, then:
docker compose -f deploy/docker-compose.dev.yml up -d --build
docker compose -f deploy/docker-compose.dev.yml config    # validate without starting
docker compose -f deploy/docker-compose.dev.yml down
```

## Conventions
- Ports are placeholders — pick non-colliding values and record them in `CLAUDE.md` Commands.
- Host-only concerns (hardware access, native services) do not belong in a container; keep those
  as scripts in this directory with their own usage notes.
