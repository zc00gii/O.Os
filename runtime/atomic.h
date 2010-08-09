#ifndef __ATOMIC_H_INCLUDED__
#define __ATOMIC_H_INCLUDED__
#ifdef __i386__
#define ATOMIC_INCREMENT(x) atomic_increment(&x) 
#define ATOMIC_DECREMENT(x) atomic_decrement(&x) 
static inline unsigned int atomic_increment(unsigned int * i)
{
	__asm__ __volatile__ (
			"lock addl $1, %0"
			:"=m" (*i));
	return *i;
}
static inline unsigned int atomic_decrement(unsigned int * i)
{
	__asm__ __volatile__ (
			"lock subl $1, %0"
			:"=m" (*i));
	return *i;
}
#elif defined(__PPC__)
#define ATOMIC_INCREMENT(x) atomic_increment(&x) 
#define ATOMIC_DECREMENT(x) atomic_decrement(&x) 
static inline unsigned int atomic_increment(unsigned int * i)
{
	    int tmp;
		__asm__ __volatile__ (
			"inc_modified:"
			"lwarx %0,0,%1 \n"
			"addic %0,%0,1 \n"
			"stwcx. %0,0,%1 \n"
			"bne- incmodified \n"
			:"=&r" (tmp)
			:"r" (i)
			:"cc", "memory");
		return *i;
}
static inline unsigned int atomic_decrement(unsigned int * i)
{
	    int tmp;
		__asm__ __volatile__ (
			"dec_modified:"
			"lwarx %0,0,%1 \n"
			"addic %0,%0,-1 \n"
			"stwcx. %0,0,%1 \n"
			"bne- dec_modified \n"
			:"=&r" (tmp)
			:"r" (i)
			:"cc", "memory");
		return *i;
}
#else
#define ATOMIC_INCREMENT(x) __builtin_fetch_and_add(&x, 1)
#define ATOMIC_DECREMENT(x) __builtin_fetch_and_sub(&x, 1)
#endif
#endif //__ATOMIC_H_INCLUDED__
