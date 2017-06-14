is_A(1).
is_A(2).
is_A(3).

is_B(1).
is_B(2).
is_B(3).

is_C(1).
is_C(2).
is_C(3).

is_D(1).
is_D(2).
is_D(3).

is_E(1).
is_E(2).
is_E(3).

is_F(1).
is_F(2).

t(_, A)::a(A).
t(_, F)::f(F).
t(_, C)::c(C).

t(_, B, A)::b(B) :- is_B(B), is_A(A), a(A).
t(_, D, A, C)::d(D) :- is_D(D), is_A(A), is_C(C), a(A), c(C).
t(_, E, B, F)::e(E) :- is_E(E), is_B(B), is_F(F), b(B), f(F).
