implement main

domains
    gender = female; male.

class facts - familyDB
    person : (string Name, gender Gender).
    parent : (string Person, string Parent).

class predicates
    father : (string Person, string Father) nondeterm anyflow.
clauses
    father(Person, Father) :-
        parent(Person, Father),
        person(Father, male).

class predicates
    mather : (string Person, string Mather) nondeterm anyflow.
clauses
    mather(Person, Mather) :-
        parent(Person, Mather),
        person(Mather, female).

class predicates
    grandFather : (string Person, string GrandFather) multi.
clauses
    grandFather(Person, GrandFather) :-
        parent(Person, Parent),
        father(Parent, GrandFather),
        stdio::write('Yes\n')
        or
        stdio::write('No\n').

class predicates
    grandMather : (string Person [out], string GrandMather [out]) nondeterm.
clauses
    grandMather(Person, GrandMather) :-
        parent(Person, Parent),
        mather(Parent, GrandMather).

class predicates
    sister : (string Person, string Sister [out]) nondeterm.
clauses
    sister(Person, Sister) :-
        mather(Sister, X),
        mather(Person, X),
        Person <> Sister,
        person(Sister, female).
    sister(Person, Sister) :-
        father(Sister, P1),
        father(Person, P1),
        Person <> Sister,
        person(Sister, female).

class predicates
    nephew : (string Person, string Nephew [out]) nondeterm.
clauses
    nephew(Person, Nephew) :-
        sister(Person, X),
        parent(Nephew, X),
        person(Nephew, male).
    nephew(Person, Nephew) :-
        brother(Person, X),
        parent(Nephew, X),
        person(Nephew, male).

class predicates
    niece : (string Person, string Niece [out]) nondeterm.
clauses
    niece(Person, Niece) :-
        sister(Person, X),
        parent(Niece, X),
        person(Niece, female).
    niece(Person, Niece) :-
        brother(Person, X),
        parent(Niece, X),
        person(Niece, female).

class predicates
    grandniece : (string Person, string Grandniece [out]) nondeterm.
clauses
    grandniece(Person, Grandniece) :-
        niece(Person, X),
        parent(Grandniece, X),
        person(Grandniece, female).
    grandniece(Person, Grandniece) :-
        nephew(Person, X),
        parent(Grandniece, X),
        person(Grandniece, female).

class predicates
    brother : (string Person, string Brother) nondeterm anyflow.
clauses
    brother(Person, Brother) :-
        mather(Brother, X),
        mather(Person, X),
        Person <> Brother,
        person(Brother, male).
    brother(Person, Brother) :-
        father(Brother, P1),
        father(Person, P1),
        Person <> Brother,
        person(Brother, male).
ьф
class predicates
    reconsult : (string FileName).
clauses
    reconsult(FileName) :-
        retractFactDB(familyDB),
        file::consult(FileName, familyDB).

clauses
    run() :-
        console::init(),
        stdio::write("Загрузка БД генеалогического древа\n"),
        reconsult(@"..\fa.txt"),
        stdio::write("\n1. Кто внучатая племянница Дэлфи? :\n"),
        X = "Delphi",
        grandniece(X, Y),
        stdio::writef("% внучатая племянница %\n", Y, X),
        fail.  /* вызывает откат к месту, сохраненному
                    в стеке точек возврата */

    run() :-
        stdio::write("\n2. Чей брат Джэк?\n"),
        X = "Jack",
        brother(Z, X),
        stdio::writef("% брат %\n", X, Z),
        fail.

    run() :-
        stdio::write("\n3. Дэвид дед Малика? \n"),
        X = "David",
        Y = "Malik",
        grandfather(Y, X),
        fail.

    run() :-
        stdio::write("\nОкончание работы программы\n").

end implement main

goal
    mainExe::run(main::run).
