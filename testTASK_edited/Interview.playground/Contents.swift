import Foundation

/**
 The task is to implement the Shop protocol (you can do that in this file directly).
 - No database or any other storage is required, just store data in memory
 - No any smart search, use String method contains (case sensitive/insensitive - does not matter)
 – Performance optimizations for listProductsByName and listProductsByProducer are optional
 */

struct Product {
    let id: String; // unique identifier
    let name: String;
    let producer: String;
}

protocol Shop {
    /**
     Adds a new product object to the Shop.
     - Parameter product: product to add to the Shop
     - Returns: false if the product with same id already exists in the Shop, true – otherwise.
     */
    func addNewProduct(product: Product) -> Bool
    
    /**
     Deletes the product with the specified id from the Shop.
     - Returns: true if the product with same id existed in the Shop, false – otherwise.
     */
    func deleteProduct(id: String) -> Bool
    
    /**
     - Returns: 10 product names containing the specified string.
     If there are several products with the same name, producer's name is added to product's name in the format "<producer> - <product>",
     otherwise returns simply "<product>".
     */
    func listProductsByName(searchString: String) -> Set<String>
    
    /**
     - Returns: 10 product names whose producer contains the specified string,
     result is ordered by producers.
     */
    func listProductsByProducer(searchString: String) -> [String]
}

// TODO: your implementation goes here
class ShopImpl: Shop {
    var products : [Product] = []
    
    init() {}
    
    func addNewProduct(product: Product) -> Bool {
        if products.filter({$0.id == product.id}).isEmpty {
            products.append(product)
            return true
        }
        return false
    }
    
    func deleteProduct(id: String) -> Bool {
        if let index = products.firstIndex(where: {$0.id == "\(id)"}) {
            products.remove(at: index)
            return true
        } else {
            return false
        }
    }
    
    func listProductsByName(searchString: String) -> Set<String> {
        var result:Set<String> = []
        var tmp: [Product] = []
        for product in products {
            if product.name.contains(searchString) && tmp.count < 10 {
                tmp.append(product)
            }
        }
        let dublicates = Dictionary(grouping: tmp, by: \.name).filter{$1.count > 1}
        let noDublicates = Dictionary(grouping: tmp, by: \.name).filter{$1.count == 1}
        noDublicates.forEach {
            prodDic in result.insert(prodDic.key)
        }
        dublicates.map {
            prodDic in prodDic.value.forEach {
                result.insert("\($0.producer) - \(prodDic.key)")
            }
        }
        
        return result
    }
    
    func listProductsByProducer(searchString: String) -> [String] {
        var tmp:[Product] = []
        for product in products {
            if product.producer.contains(searchString) && tmp.count < 10 {
                tmp.append(product)
            }
        }
        let tmpDic = Dictionary(grouping: tmp, by: \.producer).sorted {
            $0.0 < $1.0
        }
        var result: [String] = []
        tmpDic.forEach {
            $0.value.forEach {
                result.append($0.name)
            }
        }
        return result
    }
}

func test(lib: Shop) {
    assert(!lib.deleteProduct(id: "1"))
    assert(lib.addNewProduct(product: Product(id: "1", name: "1", producer: "Lex")))
    assert(!lib.addNewProduct(product: Product(id: "1", name: "any name because we check id only", producer: "any producer")))
    assert(lib.deleteProduct(id: "1"))
    assert(lib.addNewProduct(product: Product(id: "3", name: "Some Product3", producer: "Some Producer2")))
    assert(lib.addNewProduct(product: Product(id: "4", name: "Some Product1", producer: "Some Producer3")))
    assert(lib.addNewProduct(product: Product(id: "2", name: "Some Product2", producer: "Some Producer2")))
    assert(lib.addNewProduct(product: Product(id: "1", name: "Some Product1", producer: "Some Producer1")))
    assert(lib.addNewProduct(product: Product(id: "5", name: "Other Product5", producer: "Other Producer4")))
    assert(lib.addNewProduct(product: Product(id: "6", name: "Other Product6", producer: "Other Producer4")))
    assert(lib.addNewProduct(product: Product(id: "7", name: "Other Product7", producer: "Other Producer4")))
    assert(lib.addNewProduct(product: Product(id: "8", name: "Other Product8", producer: "Other Producer4")))
    assert(lib.addNewProduct(product: Product(id: "9", name: "Other Product9", producer: "Other Producer4")))
    assert(lib.addNewProduct(product: Product(id: "10", name: "Other Product10", producer: "Other Producer4")))
    assert(lib.addNewProduct(product: Product(id: "11", name: "Other Product11", producer: "Other Producer4")))
    
    var byNames: Set<String> = lib.listProductsByName(searchString: "Product")
    assert(byNames.count == 10)
    
    byNames = lib.listProductsByName(searchString: "Some Product")
    assert(byNames.count == 4)
    assert(byNames.contains("Some Producer3 - Some Product1"))
    assert(byNames.contains("Some Product2"))
    assert(byNames.contains("Some Product3"))
    assert(!byNames.contains("Some Product1"))
    assert(byNames.contains("Some Producer1 - Some Product1"))
    
    var byProducer: [String] = lib.listProductsByProducer(searchString: "Producer")
    assert(byProducer.count == 10)
    
    byProducer = lib.listProductsByProducer(searchString: "Some Producer")
    assert(byProducer.count == 4)
    assert(byProducer[0] == "Some Product1")
    assert(byProducer[1] == "Some Product2" || byProducer[1] == "Some Product3")
    assert(byProducer[2] == "Some Product2" || byProducer[2] == "Some Product3")
    assert(byProducer[3] == "Some Product1")
}

test(lib: ShopImpl())
