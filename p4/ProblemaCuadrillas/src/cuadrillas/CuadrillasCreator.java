package cuadrillas;

import java.util.Random;

import org.opt4j.core.genotype.IntegerGenotype;
import org.opt4j.core.problem.Creator;

public class CuadrillasCreator implements Creator<IntegerGenotype>
{
	public IntegerGenotype create() 
	{		
		// Aqui pondriamos un rango de 0 a 3 si quisesemos modelar descansos
		IntegerGenotype genotype = new IntegerGenotype(1,3);
		genotype.init(new Random(), Data.numeroCuardillas);  
		
		return genotype;
	}
}
