package cuadrillas;

import java.util.ArrayList;

import org.opt4j.core.genotype.IntegerGenotype;
import org.opt4j.core.problem.Decoder;

public class CuadrillasDecoder implements Decoder<IntegerGenotype, ArrayList<Integer>>
{
	//no es necesaroio devolverlo como String, pero si un tipo imprimible/visualizable en el visor Opt4J
	@Override
	public ArrayList<Integer> decode(IntegerGenotype genotype)
	{
		ArrayList<Integer> phenotype = new ArrayList<Integer>();
		//aqui se podr�a poner c�digo para validar que el fenotipo cumpla con ciertas restricciones
		for (int i = 0 ; i <genotype.size(); i++)
		{
			phenotype.add(genotype.get(i));
		}
	return phenotype;
	}
}
