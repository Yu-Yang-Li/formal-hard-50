import Mathlib

abbrev PlanePoint := ℝ × ℝ

def edgeTrace {n : ℕ} (arc : Fin n → Fin n → ℝ → PlanePoint)
    (u v : Fin n) : Set PlanePoint :=
  (arc u v) '' Set.Icc (0 : ℝ) 1

def drawingSet {n : ℕ} (G : SimpleGraph (Fin n))
    (pos : Fin n → PlanePoint) (arc : Fin n → Fin n → ℝ → PlanePoint) :
    Set PlanePoint :=
  Set.range pos ∪ {p | ∃ u v : Fin n, G.Adj u v ∧ p ∈ edgeTrace arc u v}

def IsPlaneEmbedding {n : ℕ} (G : SimpleGraph (Fin n))
    (pos : Fin n → PlanePoint) (arc : Fin n → Fin n → ℝ → PlanePoint) : Prop :=
  Function.Injective pos ∧
  (∀ u v : Fin n, G.Adj u v →
    ContinuousOn (arc u v) (Set.Icc (0 : ℝ) 1) ∧
    Set.InjOn (arc u v) (Set.Icc (0 : ℝ) 1) ∧
    arc u v 0 = pos u ∧ arc u v 1 = pos v) ∧
  (∀ u v : Fin n, G.Adj u v →
    ∀ t : ℝ, t ∈ Set.Icc (0 : ℝ) 1 → arc v u t = arc u v (1 - t)) ∧
  (∀ u v : Fin n, G.Adj u v →
    ∀ w : Fin n, ∀ t : ℝ, t ∈ Set.Ioo (0 : ℝ) 1 → arc u v t ≠ pos w) ∧
  (∀ u v x y : Fin n, G.Adj u v → G.Adj x y →
    ∀ p : PlanePoint, p ∈ edgeTrace arc u v → p ∈ edgeTrace arc x y →
      (u = x ∧ v = y) ∨ (u = y ∧ v = x) ∨
      ((p = pos u ∨ p = pos v) ∧ (p = pos x ∨ p = pos y)))

def IsDrawingFace (D F : Set PlanePoint) : Prop :=
  IsConnected F ∧ F ⊆ Dᶜ ∧
  ∀ C : Set PlanePoint, IsConnected C → C ⊆ Dᶜ → F ⊆ C → C ⊆ F

def IsPlaneTriangulation {n : ℕ} (G : SimpleGraph (Fin n)) : Prop :=
  3 ≤ n ∧
  ∃ (pos : Fin n → PlanePoint) (arc : Fin n → Fin n → ℝ → PlanePoint),
    IsPlaneEmbedding G pos arc ∧
    ∀ F : Set PlanePoint, IsDrawingFace (drawingSet G pos arc) F →
      ∃ a b c : Fin n,
        a ≠ b ∧ b ≠ c ∧ c ≠ a ∧
        G.Adj a b ∧ G.Adj b c ∧ G.Adj c a ∧
        frontier F = edgeTrace arc a b ∪ edgeTrace arc b c ∪ edgeTrace arc c a

def remainingComponent {n : ℕ} (G : SimpleGraph (Fin n))
    (S : Set (Fin n)) (v : Fin n) : Set (Fin n) :=
  {w | w ∉ S ∧
    Relation.ReflTransGen
      (fun a b : Fin n => a ∉ S ∧ b ∉ S ∧ G.Adj a b) v w}

noncomputable def remainingComponentCount {n : ℕ} (G : SimpleGraph (Fin n))
    (S : Set (Fin n)) : ℕ :=
  ({C : Set (Fin n) | ∃ v : Fin n, v ∉ S ∧ C = remainingComponent G S v} :
    Set (Set (Fin n))).ncard

def IsThreeHalvesTough {n : ℕ} (G : SimpleGraph (Fin n)) : Prop :=
  ∀ S : Set (Fin n), 2 ≤ remainingComponentCount G S →
    3 * remainingComponentCount G S ≤ 2 * S.ncard

noncomputable def vertexDegree {n : ℕ} (G : SimpleGraph (Fin n))
    (v : Fin n) : ℕ :=
  ({w : Fin n | G.Adj v w} : Set (Fin n)).ncard

def DegreeThreeVerticesSeparated {n : ℕ} (G : SimpleGraph (Fin n)) : Prop :=
  ∀ u v : Fin n, u ≠ v → vertexDegree G u = 3 → vertexDegree G v = 3 →
    ¬ G.Adj u v ∧ ∀ w : Fin n, ¬ (G.Adj u w ∧ G.Adj w v)

def HasHamiltonianCycle {n : ℕ} (G : SimpleGraph (Fin n)) : Prop :=
  ∃ f : Fin n → Fin n, Function.Bijective f ∧
    ∀ i j : Fin n, j.val = (i.val + 1) % n → G.Adj (f i) (f j)

def arxivleanConjecture : Prop :=
  ∀ (n : ℕ) (G : SimpleGraph (Fin n)), IsPlaneTriangulation G → IsThreeHalvesTough G → DegreeThreeVerticesSeparated G → HasHamiltonianCycle G
