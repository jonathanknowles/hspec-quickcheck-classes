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

To test that a type satisfies the laws of one or more type classes:

```haskell
testLaws @Bool
  [ eqLaws
  , ordLaws
  , showLaws
  ]
```

## Kind polymorphism

The `testLaws` function is **kind-polymorphic**, supporting type parameters of
any kind.

This means it can be used to test instances of type classes whose type
parameters are not of kind `Type`.

For example, with `Maybe` (which has kind `Type -> Type`):

```haskell
testLaws @Maybe
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
testLaws @Either
  [ bifoldableLaws
  , bifunctorLaws
  , bitraversableLaws
  ]
```
