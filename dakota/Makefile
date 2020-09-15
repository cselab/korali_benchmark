BINARIES = text_book
CXX=CC
CXXFLAGS=-O3

.SECONDARY:
.PHONY: all
all: $(BINARIES)

$(BINARIES) : % : %.o 
	$(CXX) -o $@ $^ 

%.o: %.cpp
	$(CXX) -c $(CXXFLAGS) $<

.PHONY: clean
clean:
	$(RM) $(BINARIES) *.o *.ti *.optrpt *.txt
