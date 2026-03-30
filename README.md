# `@recaptime-dev/infra-docker-phorge` - Docker image for Phorge in Alpine Linux

[![Docker CI](https://github.com/recaptime-dev/infra-docker-phorge/actions/workflows/docker-publish.yml/badge.svg)](https://github.com/recaptime-dev/infra-docker-phorge/actions/workflows/docker-publish.yml)

## Usage

* As a standalone Docker image:

  ```shell
  # Check docs/basic-setup.md and docs/advanced-setup.md for instructions
  # on how to set up your Phorge instance.
  docker run \
    --rm -p 80:80 -p 443:443 -p 22:22 \
    --env PHORGE_HOST=mydomain.com \
    --env MYSQL_HOST=10.0.0.1 \
    --env MYSQL_USER=user \
    --env MYSQL_PASS=pass \
    --env PHORGE_REPOSITORY_PATH=/repos \
    -v /host/repo/path:/repos \
    ghcr.io/recaptime-dev/phorge-alpine
  ```

* Via Docker Compose:

  ```shell
  docker compose up
  ```

## Documentation and Support

Docs for the Docker image can be found at the [`docs` directory](./docs).

For help in using the Docker image, you can get assistance from the RecapTime.dev crew and community through the following places:

* in the GitHub Discussions organization-wide, through [its dedicated project category](https://github.com/orgs/recaptime-dev/discussions/categories/phorge-docker-image)
* join our Zulip Cloud organization and [ask in the `projects/phorge-docker-image` channel](https://recaptime-dev.zulipchat.com/#narrow/channel/586152-projects.2Fphorge-docker-image)

If you need help with using Phorge itself, [see the upstream docs](https://we.phorge.it/book/contrib/article/bug_reports/) for details.

## License

The configuration scripts provided in this image are licensed under the MIT license.  Phorge itself and all accompanying software are licensed under their respective software licenses.
