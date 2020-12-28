# bronoverrattvik.github.io

![Bron över Rättvik](b/image.jpg)

Site for the podcast Bron över Rättvik.

[![Build Status](https://badgen.net/travis/bronoverrattvik/bronoverrattvik.github.io/master)](https://travis-ci.org/bronoverrattvik/bronoverrattvik.github.io)

## Develop

### Local

```bash
bundle exec jekyll serve
```

and open your browser at [`http://localhost:4000`](http://localhost:4000).

Or use this command to build site with production settings:
```cmd
SET JEKYLL_ENV=production && bundle exec jekyll serve
```

### Docker

```bash
docker-compose up
```

and open your browser at [`http://localhost:4000`](http://localhost:4000).

TODO: Find another Docker solution (the `github-pages` gem is at [version 202](https://github.com/Starefossen/docker-github-pages/blob/master/Dockerfile) in `starefossen/github-pages`).
