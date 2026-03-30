# `hspec-quickcheck-classes`

[![Latest Release](
  https://img.shields.io/hackage/v/hspec-quickcheck-classes?label=Latest%20Release&color=227755
)](https://hackage.haskell.org/package/hspec-quickcheck-classes)
[![Development Branch](
  https://img.shields.io/badge/Development%20Branch-API%20Documentation-225577
)](https://jonathanknowles.github.io/hspec-quickcheck-classes/)

This package integrates [Hspec](https://hackage.haskell.org/package/hspec) with
[quickcheck-classes](https://hackage.haskell.org/package/quickcheck-classes),
making it convenient for Hspec test suites to include tests for the lawfulness
of type class instances.

# Usage

## Testing a single type class instance

Use `testLaws` to test that a specified type satisfies the laws of a single
type class:

```haskell
testLaws @Bool eqLaws
```

## Testing multiple type class instances

Use `testLawsMany` to test that a specified type satisfies the laws of multiple
type classes:

```haskell
testLawsMany @Bool
  [ eqLaws
  , ordLaws
  , showLaws
  , showReadLaws
  ]
```

## Kind polymorphism

Both `testLaws` and `testLawsMany` are **kind-polymorphic**, supporting type
parameters of any kind.

This means they can be used to test instances of type classes whose type
parameters are not of kind `Type`.

For example, with `Maybe` (which has kind `Type -> Type`):

```haskell
testLawsMany @Maybe
  [ alternativeLaws
  , applicativeLaws
  , functorLaws
  , monadLaws
  , foldableLaws
  , traversableLaws
  ]
```

And with `Either` (which has kind `Type -> Type -> Type`):

```haskell
testLawsMany @Either
  [ bifoldableLaws
  , bifunctorLaws
  , bitraversableLaws
  ]
```
