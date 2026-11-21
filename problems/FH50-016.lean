import Mathlib

theorem ramsey_matching_with_Kss_free_complement
    (s q : ℕ) (hs : 1 ≤ s) (hq : 1 ≤ q) (t : Fin q → ℕ) (ht : ∀ j, 1 ≤ t j) :
    IsLeast
      {N : ℕ |
        ∀ (V : Type) [Fintype V] [DecidableEq V],
          Fintype.card V = N →
            ∀ G : SimpleGraph V,
              (∀ A B : Finset V,
                A.card = s → B.card = s → Disjoint A B →
                  ∃ a ∈ A, ∃ b ∈ B, G.Adj a b) →
                ∀ C : Fin q → SimpleGraph V,
                  (∀ j x y, (C j).Adj x y → G.Adj x y) →
                    (∀ x y, G.Adj x y → ∃! j : Fin q, (C j).Adj x y) →
                      ∃ j : Fin q, ∃ M : Finset (V × V),
                        M.card = t j ∧
                          (∀ p ∈ M, (C j).Adj p.1 p.2) ∧
                            (∀ p ∈ M, ∀ p' ∈ M, p ≠ p' →
                              p.1 ≠ p'.1 ∧ p.1 ≠ p'.2 ∧
                                p.2 ≠ p'.1 ∧ p.2 ≠ p'.2)}
      ((∑ j : Fin q, (t j - 1)) + max (2 * s) (s + (Finset.univ.sup fun j : Fin q => t j))) := by
  sorry
