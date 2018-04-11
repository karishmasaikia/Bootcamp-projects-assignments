from store import Store

#Store('sports authority').greet_customer()


store_names=['Barnes & Noble',
'Sports Authority',
'Safeway']

csv_file_paths=['books.csv',
'sporting_goods.csv',
'groceries.csv']



store_data=zip(store_names,csv_file_paths)

stores=[Store(store_datum[0]) for store_datum in store_data]


def quit():
    print('Goodbye')
    print('Bye')

def user_wants_to_quit(command):
    return commad=='q'

for store in stores:
    store.greet_customer()

#it combines as a tuple
#print(list(store_data))

def prompt_to_enter_store():
    command=input("What wud u like to do (e)nter a store, (q)uit")

    if command=='e':
        
        prompt_which_store()
    elif user_wants_to_quit(command):
        quit()
    else:
        
       prompt_to_enter_store()

def prompt_which_store():
    for index, store in enumerate(stores):
        print(f"({index} {store.name})")
        #store.greet_customer()

    command = input("Which store do u wanna select")

    if command.isdigit() and 0 <= int(command) < len(stores):
        store=stores[int(command)]
        store.greet_customer()
    elif user_wants_to_quit(command):
        quit()
    else:
        prompt_which_store()

prompt_to_enter_store() 