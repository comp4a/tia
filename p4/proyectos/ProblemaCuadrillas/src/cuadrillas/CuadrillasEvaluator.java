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
			int c1 = 0, c2 = 0, c3 = 0;
			//int descanso = 0;

			
			for (int i = 0; i < phenotype.size(); ++i)
			{

				switch (phenotype.get(i))
				{
				case 1: coste += Data.turno1[i+1]; productividad += Data.productividad1[i+1]; c1++; break;
				case 2: coste += Data.turno2[i+1]; productividad += Data.productividad2[i+1]; c2++; break;
				case 3: coste += Data.turno3[i+1]; productividad += Data.productividad3[i+1]; c3++; break;
				}
			}
			
			/*
			if(descanso > 1) {
				resultado += 10000 * descanso;	
			}
			*/
			
			/*
Si en un mismo turno están las cuadrillas 2 y 4 la productividad se incrementa en 100 unidades.
Si en un mismo turno están las cuadrillas 1 y 6 la productividad se decrementa en 50 unidades.
			 */
			
			if(phenotype.get(2-1) == phenotype.get(4-1) ) {
				productividad += 100;
			}
			
			if(phenotype.get(1-1) == phenotype.get(6-1) ) {
				productividad -= 50;
			}
			
			if (c1<2 || c2<2 || c3<2) {
				coste=Integer.MAX_VALUE;
				productividad = Integer.MIN_VALUE;
			}
			
			
			Objectives objectives = new Objectives();
			objectives.add("Valor coste-MIN",  Sign.MIN, Math.abs(coste));
			objectives.add("Valor productividad-MAX", Sign.MAX, Math.abs(productividad));
			return objectives;
	}
}

