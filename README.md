# Nexus repository provisioning script

Uses Nexus Script API to store and run scripts responsible for creating repositories.

## Usage

In `repositories` directory create `.json` files containing scripts to create repositories.

Filename is decisive when executing remote scripts, therefor file `npm.json` must create a `npm` remote script by containing 
```
"name" : "npm"
```

Format and contents MUST conform to API definition

Some examples can be found at [sonatype/nexus-book-examples](https://github.com/sonatype/nexus-book-examples/)

Api documentation can be found under `API` in settings page of Nexus

Idempotency MUST be assured by author of scripts, as this tool is only capable of calling endpoints.

## Execution

Run `run.sh`