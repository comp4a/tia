package operaciones.aritmeticas;

import java.util.Random;

import org.opt4j.core.genotype.SelectGenotype;
import org.opt4j.core.gproblem.creator;

public class OpsAritmeticasCreator implements Creator<SelectGenotype<MathematicalSymbol>>
{
	public SelectGenotype<MathematicalSymbol> create()
	{
		MathematicalSymbol[] Symbols = {MathematicalSymbol.PLUS, MathematicalSymbol.MINUS,
				MathematicalSymbol.MULTIPLICATION, MathematicalSymbol.DIVISION};
		
		SelectGenotype<MathematicalSymbol> genotype = new SelectGenotype<MathematicalSymbol>(Symbols);
		// El genoripo estará formado por "numeroSimbolos" matematicos elegidos al azar
		// En nuestro caso la población será un conjunto de individuos, donde cada individuo son 5 símbolos
		genotype.init(new Random(), Data.numeroSimbolos);
		
		return genotype;
	}
}
