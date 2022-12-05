:- module( c,
           [ all_courses/2,
             in_case/3,
             in/4
           ]).
:- use_module(database).

all_courses(Grade, Courses) :-
    findall(X, (database:c(Grade, N, Course),
                once(findnsols(N, Course, repeat, X))
               ), L),
    flatten(L, Courses).

in_case(Grade, Courses, Case) :-
    findall(N, database:cs(Grade, _D, N), L),
    %% P(32, 32) = (32!)/(32-32)! = 32! = 2.631308369E+35
    permutation(Courses, P),
    perm_case(P, L, [], Case).

perm_case([], [], Acc, Case) :-
    reverse(Acc, Case).
perm_case(List, [N|Ns], Acc, Cases) :-
    append(L, R, List),
    length(L, N),
    perm_case(R, Ns, [L|Acc], Cases).

% in(課程, 節數, 週日數, [[...],[...],[...],[...],[...],...])
%                ^ 排列
in(C, N, D, L) :-
    n(D, N, L).

n(N, M, L) :-
    findnsols(N, M, repeat, L), !.

% ?- findnsols(3, 1, repeat, L), !.
% L = [1, 1, 1].
