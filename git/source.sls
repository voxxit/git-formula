{% set git = pillar.get('git', {}) -%}
{% set version = git.get('version', '2.3.0') -%}
{% set checksum = git.get('checksum', 'sha256=ba2fe814e709a5d0f034ebe82083fce7feed0899b3a8c8b3adf1c5a85d1ce9ac') -%}
{% set source = git.get('source_root', '/usr/local/src') -%}

{% set git_package = source + '/git-' + version + '.tar.gz' -%}

get-git:
  pkg.installed:
      - names:
        - libcurl4-openssl-dev
        - libexpat1-dev
        - gettext
        - libz-dev
        - libssl-dev
        - build-essential
  file.managed:
    - name: {{ git_package }}
    - source: https://git-core.googlecode.com/files/git-{{ version }}.tar.gz
    - source_hash: {{ checksum }}
  cmd.wait:
    - cwd: {{ source }}
    - name: tar -zxf {{ git_package }}
    - require:
      - pkg: get-git
    - watch:
      - file: get-git

git:
  pkg.removed:
    - name: git
  cmd.wait:
    - cwd: {{ source + '/git-' + version }}
    - name: make prefix=/usr/local all && make prefix=/usr/local install
    - watch:
      - cmd: get-git
    - require:
      - cmd: get-git
