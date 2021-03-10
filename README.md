# webapi repository
template repository for deep learning


# setup

## build container

```
make
```

## build vue environment

### create project

```
make frontend-init
```

### install libraries for project

```
make frontend-install
```

### restore vue ci environment

you should use this task after `git clone` this repository

```
make frontend-ci
```

# use

## dev environment

```
make frontend-dev
```

## prod environment

```
make frontend-build
```
