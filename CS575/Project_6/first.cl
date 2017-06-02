kernel
void
ArrayMult( global const float *dA, global const float *dB, global float *dC )
{
	int gid = get_global_id( 0 );

	dC[gid] = dA[gid] * dB[gid];
}

kernel
void
ArrayMultAdd( global const float *dA, global const float *dB, global const float *dC, global float *dD )
{
	int gid = get_global_id( 0 );

	dD[gid] = dA[gid] * dB[gid] + dC[gid];
}

kernel
void
ArrayMultReduce( global const float *dA, global const float *dB, local float *prods, global float *dC )
{
	int gid = get_global_id( 0 ); // 0 .. total_array_size-1
	int numItems = get_local_size( 0 ); // # work-items per work-group
	int tnum = get_local_id( 0 ); // thread (i.e., work-item) number in this work-group
	// 0 .. numItems-1
	int wgNum = get_group_id( 0 ); // which work-group number this is in
	prods[ tnum ] = dA[ gid ] * dB[ gid ]; // multiply the two arrays together

	// all threads execute this code simultaneously:
	for( int offset = 1; offset < numItems; offset *= 2 )
	{
		int mask = 2*offset - 1;
		barrier( CLK_LOCAL_MEM_FENCE ); // wait for completion
		if( ( tnum & mask ) == 0 )
		{
			prods[ tnum ] += prods[ tnum + offset ];
		}
	}
	barrier( CLK_LOCAL_MEM_FENCE );
	if( tnum == 0 )
	dC[ wgNum ] = prods[ 0 ];

}
