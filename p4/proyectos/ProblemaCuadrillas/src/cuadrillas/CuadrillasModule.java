package cuadrillas;

import org.opt4j.core.problem.ProblemModule;

public class CuadrillasModule  extends ProblemModule
{
protected void config() {
	bindProblem(CuadrillasCreator.class, CuadrillasDecoder.class, CuadrillasEvaluator.class);
}
}
