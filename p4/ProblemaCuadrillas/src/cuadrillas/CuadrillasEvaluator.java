package cuadrillas;

import java.util.ArrayList;
import org.opt4j.core.Objectives;
import org.opt4j.core.Objective.Sign;
import org.opt4j.core.problem.Evaluator;

public class CuadrillasEvaluator implements Evaluator<ArrayList<Integer>>
{
	@Override
	public Objectives evaluate (ArrayList<Integer> phenotype)
	{
			int resultado = 0;
			int coste = 0;
			int productividad = 0;
			//int descanso = 0;

			
			for (int i = 0; i < phenotype.size(); ++i)
			{
				switch (phenotype.get(i))
				{
				case 1: coste += Data.turno1[i+1]; productividad += Data.productividad1[i+1]; break;
				case 2: coste += Data.turno2[i+1]; productividad += Data.productividad2[i+1]; break;
				case 3: coste += Data.turno3[i+1]; productividad += Data.productividad3[i+1]; break;
				//case 0: descanso++; break;
				}
			}
			
			/*
			if(descanso > 1) {
				resultado += 10000 * descanso;	
			}
			*/
			
			resultado = coste - productividad;
			
			
	Objectives objectives = new Objectives();
	objectives.add("Valor objetivo-MIN",  Sign.MIN, Math.abs(resultado));
	return objectives;
	}
}

