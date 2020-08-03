function eqn = create_eq1_sq(eq)
eq5 = eq(1);
eq4 = eq(2);
eq3 = eq(3);
eq2 = eq(4);
eq1 = eq(5);
eq0 = eq(6);
eqn=[eq5^2,eq4*eq5*2.0,eq3*eq5*2.0+eq4^2,eq2*eq5*2.0+eq3*eq4*2.0,eq1*eq5*2.0+eq2*eq4*2.0+eq3^2,...
eq0*eq5*2.0+eq1*eq4*2.0+eq2*eq3*2.0,eq0*eq4*2.0+eq1*eq3*2.0+eq2^2,eq0*eq3*2.0+eq1*eq2*2.0,eq0*eq2*2.0+eq1^2,...
eq0*eq1*2.0,eq0^2];