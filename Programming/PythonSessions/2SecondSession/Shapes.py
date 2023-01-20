class Shape:
    
    def __init__(self, name,base,height):
        self.name = name
        self.base = base
        self.height = height
        
    def __repr__(self):
        return f"Shape({self.name}, {repr(self.base)},{repr(self.height)},{repr(self.area)})"
    
    def __str__(self):
        return f"{self.name.title()}"
        
    @staticmethod
    def bigger(figure1,figure2):
        if figure1.area > figure2.area:
            print(figure1, "is bigger than", figure2)
        else:
            print(figure2, "is bigger than", figure1)
    
    @classmethod
    def summingFigs(cls,name,figure1,figure2):
        raise NotImplementedError("Went to the parent class to search for this method.")

             
class Circle(Shape):
    
    def __init__(self, name, radius, area):
        super().__init__(name, radius, radius) # The super() method, allows to invoke methods defined on the base class.
        # THIS IS THE ONLY NEEDED CHANGE BETWEEN GEOMETRICAL FIGURES
        self.area = radius*radius*3.14
    
    def __repr__(self):
        return f"Shape({self.name}, {repr(self.base)},{repr(self.area)})"
    
    @classmethod
    def summingFigs(cls,name,figure1,figure2):
        return cls(name, figure1.base + figure2.base, None)
    
    @classmethod
    def summingNums(cls,name,figure1,num):
        return cls(name, figure1.base + num, None)
        
        
class Triangle(Shape):
    def __init__(self, name, side1, side2, side3, area):
        # super().__init__(name, side1, side2, side3) # The super() method, allows to invoke methods defined on the base class.
        # THIS IS THE ONLY NEEDED CHANGE BETWEEN GEOMETRICAL FIGURES UNLESS IT HAS DIFFERENT SIDES
        self.name = name
        self.side1 = side1
        self.side2 = side2
        self.side3 = side3
        
        s = (side1 + side2 + side3)/2
        self.area = (s * (s - side1) * (s - side2) * (s - side3))**(0.5)
        
        if side1 + side2 < side3 or side2 + side3 < side1 or side3 + side1 < side2:
            print("This triangle is not closed!")
        
    def __repr__(self):
        return f"Shape({self.name}, {repr(self.side1)},{repr(self.side2)},{repr(self.side3)},{repr(self.area)})"
    
    def __str__(self):
        return f"{self.name.title()}"
    
    @classmethod
    def summingFigs(cls,name,figure1,figure2):
        return cls(name, figure1.side1 + figure2.side1, figure1.side2 + figure2.side2, figure1.side3 + figure2.side3, None)
    
    @classmethod
    def summingNums(cls,name,figure1,num):
        return cls(name, figure1.side1 + num, figure1.side2 + num, figure1.side3 + num, None)
        
        
class Rectangle(Shape):
    def __init__(self, name, base, height, area):
        super().__init__(name, base, height) # The super() method, allows to invoke methods defined on the base class.
        # THIS IS THE ONLY NEEDED CHANGE BETWEEN GEOMETRICAL FIGURES
        self.area = base*height
        
    # We will comment this part for the method to be run on the parent class
    # @classmethod
    # def summingFigs(cls,name,figure1,figure2):
    #     return cls(name, figure1.base + figure2.base, figure1.height + figure2.height, None)
    
    @classmethod
    def summingNums(cls,name,figure1,num):
        return cls(name, figure1.base + num, figure1.height + num, None)